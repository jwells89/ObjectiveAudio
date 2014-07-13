//
//  OAAudioPlayer.m
//  ObjectiveAudio
//
//  Created by John Wells on 2/7/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "OAAudioPlayer.h"
#import "OAUtilities.h"
#import <SFBAudioEngine/AudioPlayer.h>
#import <SFBAudioEngine/CoreAudioOutput.h>
#import <SFBAudioEngine/Logger.h>
#import "MSWeakTimer.h"


enum ePlayerFlags : unsigned int {
    ePlayerFlagRenderingStarted			= 1u << 0,
    ePlayerFlagRenderingFinished		= 1u << 1
};

static NSInteger const DefaultNextObjectQueueThreshold = 1.5;

@interface OAAudioPlayer (Callbacks)
- (void)updateTimerFired:(MSWeakTimer *)timer;
@end

@interface OAAudioPlayer () {
    SFB::Audio::Player *_player;
    std::atomic_uint	_playerFlags;
    
}

@property (strong, nonatomic) MSWeakTimer *updateTimer;

@end

@implementation OAAudioPlayer

- (id)init
{
    self = [super init];
    if (self) {
        _player = new SFB::Audio::Player;
        
        _playerFlags = 0;
        
		_player->SetRenderingStartedBlock(^(const SFB::Audio::Decoder& /*decoder*/){
			_playerFlags.fetch_or(ePlayerFlagRenderingStarted);
		});
        
		_player->SetRenderingFinishedBlock(^(const SFB::Audio::Decoder& /*decoder*/){
			_playerFlags.fetch_or(ePlayerFlagRenderingFinished);
		});
        
        _updateTimer = [MSWeakTimer scheduledTimerWithTimeInterval:(1.0 /5) target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
        
        _nextObjectQueueThreshold = DefaultNextObjectQueueThreshold;
        
        SFB::Audio::Decoder::SetAutomaticallyOpenDecoders(YES);
        
        asl_add_log_file(nullptr, STDERR_FILENO);
        ::SFB::Logger::SetCurrentLevel(::SFB::Logger::debug);
    }
    return self;
}

-(void)dealloc
{
    [_updateTimer invalidate];
    _updateTimer = nil;
    _player->~Player();
}

-(void)cleanUp
{
    _player->SetRenderingStartedBlock(^(const SFB::Audio::Decoder &decoder) {
        
    });
    
    _player->SetRenderingFinishedBlock(^(const SFB::Audio::Decoder &decoder) {
        
    });
}

-(NSInteger)playObject:(OAAudioObject *)object
{
    if (object != nil) {
        auto song = SFB::Audio::Decoder::CreateForURL((__bridge CFURLRef)object.fileURL);
        
        if (song == nullptr) {
            return NO;
        }
        
        self.queueController.currentObject = object;
        self.queueController.nextObject = nil;
        _player->Play(song);
        return YES;
    }
    
    return NO;
    return self.playerState;
}

-(NSInteger)playURL:(NSURL *)url
{
    if (url != nil) {
        self.nextObjectHasBeenQueued = NO;
        if (_player->Play((__bridge CFURLRef)url))
        {
            return OAPlayerStatePlaying;
        } else {
            return OAPlayerStateStopped;
        }
    }

    return self.playerState;
}

-(NSInteger)play
{

    _player->Play();
    [self.delegate audioPlayerStateDidChange:self];

    
    return self.playerState;
}

-(NSInteger)pause
{

    _player->Pause();
    [self.delegate audioPlayerStateDidChange:self];

    
    return self.playerState;
}

-(NSInteger)stop
{

    _player->Stop();

    
    return self.playerState;
}

-(NSInteger)playPause
{

    _player->PlayPause();
    [self.delegate audioPlayerStateDidChange:self];
    
    return self.playerState;
}

-(IBAction)playPause:(id)sender
{
    [self playPause];
}

-(BOOL)skipToPreviousTrack
{
    if ([self playObject:[self.queueController previousObject]]) {
        return YES;
    }
    
    return NO;
}

-(void)skipToPreviousTrack:(id)sender
{
    [self skipToPreviousTrack];
}

-(BOOL)skipToNextTrack
{
    if ([self queueNextSong]) {
        return _player->SkipToNextTrack();
    }
    
    return NO;
}

-(void)skipToNextTrack:(id)sender
{
    [self skipToNextTrack];
}

-(BOOL)queueObject:(OAAudioObject *)object
{
    if (object != nil) {
        auto song = SFB::Audio::Decoder::CreateForURL((__bridge CFURLRef)object.fileURL);
        
        if (song == nullptr) {
            return NO;
        }
        
        [self.queueController setCurrentObject:object];
        _player->Enqueue(song);
        return YES;
    }
    
    return NO;
}

-(BOOL)queueDecoder:(std::unique_ptr<SFB::Audio::Decoder>)decoder
{
    if ((_player->Enqueue(decoder)) == false) {
        return NO;
    }
    
    return YES;
}

-(BOOL)queueURL:(NSURL *)url
{
    auto song = SFB::Audio::Decoder::CreateForURL((__bridge CFURLRef)url);
    
    return _player->Enqueue(song);
}

-(BOOL)queueNextSong
{
    _player->ClearQueuedDecoders();
    if ([self queueObject:[self.queueController nextObject]]) {
        return YES;
    }
    
    return NO;
}

-(void)maxVolume:(id)sender
{
    [self setVolume:1.0];
    [self.delegate audioPlayerVolumeDidChange:self];
}

-(void)muteVolume:(id)sender
{
    [self setVolume:0.0];
}

-(IBAction)setVolumeFromSender:(id)sender
{
    if ([sender floatValue]) {
        [self setVolume:[sender floatValue]];
        if ([self.delegate respondsToSelector:@selector(audioPlayerVolumeDidChange:)]) {
            [self.delegate audioPlayerVolumeDidChange:self];
        }
    }
}

-(IBAction)setPositionFromSender:(id)sender
{
    [self setCurrentPosition:[sender doubleValue]];

}

-(OAPlayerState)playerState
{
    switch (_player->GetPlayerState()) {
        case SFB::Audio::Player::PlayerState::Playing:
            return OAPlayerStatePlaying;
            break;
            
        case SFB::Audio::Player::PlayerState::Paused:
            return OAPlayerStatePaused;
            break;
            
        case SFB::Audio::Player::PlayerState::Stopped:
            return OAPlayerStateStopped;
            break;
            
        case SFB::Audio::Player::PlayerState::Pending:
            return OAPlayerStatePending;
            break;
            
        default: return OAPlayerStateStopped;
            break;
    }
}

-(BOOL)isPlaying
{
    return self.playerState == OAPlayerStatePlaying;
}

-(double)currentPosition
{
    SInt64 currentFrame, totalFrames;
    CFTimeInterval currentTime, totalTime;
    double fractionComplete = -1;
    
    if(_player) {
        if(_player->GetPlaybackPositionAndTime(currentFrame, totalFrames, currentTime, totalTime)) {
            fractionComplete = static_cast<double>(currentFrame) / static_cast<double>(totalFrames);
        }
    }
    
    return fractionComplete;
}

-(void)setCurrentPosition:(double)currentPosition
{
    SInt64 totalFrames;
	if(_player->GetTotalFrames(totalFrames)) {
		SInt64 desiredFrame = static_cast<SInt64>(currentPosition * totalFrames);
		_player->SeekToFrame(desiredFrame);
	}
}

+(NSSet *)keyPathsForValuesAffectingElapsedTimeStringValue
{
    return [NSSet setWithObject:@"currentPosition"];
}

+(NSSet *)keyPathsForValuesAffectingRemainingTimeStringValue
{
    return [NSSet setWithObject:@"currentPosition"];
}

-(float)volume
{
    float volume;
    dynamic_cast<SFB::Audio::CoreAudioOutput&>(_player->GetOutput()).GetVolume(volume);
    
    return _player ? volume : -1;
}

-(void)setVolume:(float)volume
{
    dynamic_cast<SFB::Audio::CoreAudioOutput&>(_player->GetOutput()).SetVolume(volume);
    if ([self.delegate respondsToSelector:@selector(audioPlayerVolumeDidChange:)]) {
        [self.delegate audioPlayerVolumeDidChange:self];
    }
}

-(NSURL *)playingURL
{
    return _player->GetPlayingURL() ? (__bridge NSURL *)_player->GetPlayingURL() : nil;
}

-(OAAudioObject *)playingItem
{
    return [self.queueController currentObject];
}

-(float)elapsedTime
{
    SInt64 currentFrame, totalFrames;
	CFTimeInterval currentTime, totalTime;
    float elapsedTime = 0;
    
    if(_player) {
        if(_player->GetPlaybackPositionAndTime(currentFrame, totalFrames, currentTime, totalTime)) {
            elapsedTime = currentTime;
        }
    }
    return elapsedTime;
}

-(float)remainingTime
{
    SInt64 currentFrame, totalFrames;
	CFTimeInterval currentTime, totalTime;
    float remainingTime = 0;
    
    if(_player) {
        if(_player->GetPlaybackPositionAndTime(currentFrame, totalFrames, currentTime, totalTime)) {
            remainingTime = totalTime-currentTime;
        }
    }
    return remainingTime;
}

-(NSString *)elapsedTimeStringValue
{
    return [OAUtilities formatDurationWithSeconds:self.elapsedTime];
}

-(NSString *)remainingTimeStringValue
{
    return [OAUtilities formatDurationWithSeconds:self.remainingTime];
}

@end

@implementation OAAudioPlayer (Callbacks)

-(void)updateTimerFired:(NSTimer *)timer
{
    auto flags = _playerFlags.load();
    
	if(ePlayerFlagRenderingStarted & flags) {
		_playerFlags.fetch_and(~ePlayerFlagRenderingStarted);
        if ([self.delegate respondsToSelector:@selector(audioPlayerStateDidChange:)]) {
            [self.delegate audioPlayerStateDidChange:self];
        }
        if ([self.delegate respondsToSelector:@selector(audioPlayerSongDidChange:)]) {
            [self.delegate audioPlayerSongDidChange:self];
        }
        
        self.nextObjectHasBeenQueued = NO;
        
		return;
	}
	else if(ePlayerFlagRenderingFinished & flags) {
		_playerFlags.fetch_and(~ePlayerFlagRenderingFinished);
        if ([self.delegate respondsToSelector:@selector(audioPlayerStateDidChange:)]) {
            [self.delegate audioPlayerStateDidChange:self];
            }
        
		return;
	}
    
    if (self.playerState == OAPlayerStatePlaying) {
        [self willChangeValueForKey:@"currentPosition"];
        if ([self.delegate respondsToSelector:@selector(audioPlayerPositionDidChange:)]) {
            [self.delegate audioPlayerPositionDidChange:self];
        }
        [self didChangeValueForKey:@"currentPosition"];
        
        if (self.remainingTime <= self.nextObjectQueueThreshold && self.nextObjectHasBeenQueued == NO) {
            [self queueNextSong];
            self.nextObjectHasBeenQueued = YES;
        }
    }
}

@end
