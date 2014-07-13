//
//  OAAudioPlayer.h
//  ObjectiveAudio
//
//  Created by John Wells on 2/7/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAQueueController.h"
#import "OAAudioPlayerDelegate.h"
#import "OAAudioObject.h"

typedef enum OAPlayerState : NSInteger {
    OAPlayerStateStopped = 0,
    OAPlayerStatePlaying = 1,
    OAPlayerStatePaused  = 2,
    OAPlayerStatePending = 3
    } PlayerState;

@interface OAAudioPlayer : NSObject

@property (weak) IBOutlet id<OAAudioPlayerDelegate> delegate;
@property (weak) IBOutlet OAQueueController *queueController;

/**
 The player's position in its currently playing song.
 @return \c -1 if nothing is currently playing;
 */
@property (nonatomic) double currentPosition;

/**
 The player's current volume.
 */
@property (nonatomic) float volume;

/**
 Returns the player's current state.
 */
@property (readonly) enum OAPlayerState playerState;
@property (readonly) BOOL isPlaying;

/**
 Returns the \c NSURL currently being played by the player.
 */
@property (readonly) NSURL *playingURL;

/**
 Returns the \c OAAudioObject currently being played by the player.
 */
@property (readonly) OAAudioObject *playingItem;

/**
 Returns the player's elapsed time as a string.
 Example usage:
 @code
 NSString *elapsedTime = [audioPlayer elapsedTimeStringValue];
 
 [elapsedTimeTextField setStringValue: elapsedTime];
 @endcode
 @return The player's elapsed time as a string formatted as the following: \c 00:00:00
 */
@property (readonly) NSString *elapsedTimeStringValue;

/**
 Returns the player's remaining time as a string.
 Example usage:
 @code
 NSString *elapsedTime = [audioPlayer remainingTimeStringValue];
 
 [remainingTimeTextField setStringValue: remainingTime];
 @endcode
 @return The player's remaining time as a string formatted as the following: \c 00:00:00
 */
@property (readonly) NSString *remainingTimeStringValue;

/**
 Returns the player's elapsed time as a float.
 */
@property (readonly) float elapsedTime;

/**
 Returns the player's remaining time as a float.
 */
@property (readonly) float remainingTime;

/**
 Threshold for queueing the next song.
 Example usage:
 @code
 OAAudioPlayer *audioPlayer;
 
 [audioPlayer setNextObjectQueueThreshold: 5.0];
 @endcode
 @return Amount of remaining time in seconds at which point the player should attempt to queue the song returned by delegate methods \c audioPlayerWillQueueNextObject or \c audioPlayerWillQueueNextURL. Default value is \c 1.5.
 */
@property float nextObjectQueueThreshold;

/**
 Whether or not the next object has been queued.
 */
@property BOOL nextObjectHasBeenQueued;

- (NSInteger)playURL:(NSURL *)url;
- (NSInteger)playObject:(OAAudioObject *)object;
- (NSInteger)play;
- (NSInteger)pause;
- (NSInteger)stop;
- (NSInteger)playPause;
- (BOOL)skipToPreviousTrack;
- (BOOL)skipToNextTrack;
- (IBAction)playPause:(id)sender;
- (BOOL)queueObject:(OAAudioObject *)object;
- (BOOL)queueURL:(NSURL *)url;
- (void)cleanUp;

// IBActions
- (IBAction)maxVolume:(id)sender;
- (IBAction)muteVolume:(id)sender;
- (IBAction)skipToPreviousTrack:(id)sender;
- (IBAction)skipToNextTrack:(id)sender;
- (IBAction)setVolumeFromSender:(id)sender;
- (IBAction)setPositionFromSender:(id)sender;

@end
