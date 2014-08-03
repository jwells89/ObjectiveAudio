//
//  OAAudioMetadata.m
//  ObjectiveAudio
//
//  Created by John Wells on 7/16/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//
//  Parts adapated from Sonora (http://github.com/sonoramac/sonora/)

#import "OAAudioMetadata.h"
#import <SFBAudioEngine/AudioMetadata.h>

@implementation OAAudioMetadata {
    std::unique_ptr<SFB::Audio::Metadata> _metadata;
}

-(instancetype)initWithFileAtURL:(NSURL *)fileURL
{
    if ((self = [super init])) {
        if (!fileURL) {
            return nil;
        }
        _metadata = SFB::Audio::Metadata::CreateMetadataForURL((__bridge CFURLRef)fileURL);
        if (_metadata == NULL) {
            return nil;
        }
    }
    return self;
}

-(instancetype)initWithAudioObject:(OAAudioObject *)audioObject
{
    return [[OAAudioMetadata alloc] initWithFileAtURL:audioObject.fileURL];
}

- (BOOL)readMetadata
{
    return (BOOL)_metadata->ReadMetadata();
}

- (BOOL)writeMetadata
{
    return (BOOL)_metadata->WriteMetadata();
}

- (BOOL)hasUnsavedChanges
{
    return (BOOL)_metadata->HasUnsavedChanges();
}

- (void)revertUnsavedChanges
{
    _metadata->RevertUnsavedChanges();
}

#pragma mark -
#pragma mark Audio Properties

- (NSURL*)url
{
    return (__bridge NSURL*)_metadata->GetURL();
}

- (NSString*)formatName
{
    return (__bridge NSString*)_metadata->GetFormatName();
}

- (NSNumber*)totalFrames
{
    return (__bridge NSNumber*)_metadata->GetTotalFrames();
}

- (NSNumber*)channelsPerFrame
{
    return (__bridge NSNumber*)_metadata->GetChannelsPerFrame();
}

- (NSNumber*)bitsPerChannel
{
    return (__bridge NSNumber*)_metadata->GetBitsPerChannel();
}

- (NSNumber*)sampleRate
{
    return (__bridge NSNumber*)_metadata->GetSampleRate();
}

- (NSNumber*)duration
{
    return (__bridge NSNumber*)_metadata->GetDuration();
}

- (NSNumber*)bitrate
{
    return (__bridge NSNumber*)_metadata->GetBitrate();
}

#pragma mark -
#pragma mark Metadata Access

- (NSString*)title
{
    return (__bridge NSString*)_metadata->GetTitle();
}

- (void)setTitle:(NSString *)title
{
    _metadata->SetTitle((__bridge CFStringRef)title);
}

- (NSString*)albumTitle
{
    return (__bridge NSString*)_metadata->GetAlbumTitle();
}

- (void)setAlbumTitle:(NSString *)albumTitle
{
    _metadata->SetAlbumTitle((__bridge CFStringRef)albumTitle);
}

- (NSString*)artist
{
    return (__bridge NSString*)_metadata->GetArtist();
}

- (void)setArtist:(NSString *)artist
{
    _metadata->SetArtist((__bridge CFStringRef)artist);
}

- (NSString*)albumArtist
{
    return (__bridge NSString*)_metadata->GetAlbumArtist();
}

- (void)setAlbumArtist:(NSString *)albumArtist
{
    _metadata->SetAlbumArtist((__bridge CFStringRef)albumArtist);
}

- (NSString*)genre
{
    return (__bridge NSString*)_metadata->GetGenre();
}

- (void)setGenre:(NSString *)genre
{
    _metadata->SetGenre((__bridge CFStringRef)genre);
}

- (NSString*)composer
{
    return (__bridge NSString*)_metadata->GetComposer();
}

- (void)setComposer:(NSString *)composer
{
    _metadata->SetComposer((__bridge CFStringRef)composer);
}

- (NSString*)releaseDate
{
    return (__bridge NSString*)_metadata->GetReleaseDate();
}

- (void)setReleaseDate:(NSString *)releaseDate
{
    _metadata->SetReleaseDate((__bridge CFStringRef)releaseDate);
}

- (NSNumber*)compilation
{
    return (__bridge NSNumber*)_metadata->GetCompilation();
}

- (void)setCompilation:(NSNumber*)isCompilation
{
    _metadata->SetCompilation((__bridge CFBooleanRef)isCompilation);
}

- (NSNumber*)trackNumber
{
    return (__bridge NSNumber*)_metadata->GetTrackNumber();
}

- (void)setTrackNumber:(NSNumber *)trackNumber
{
    _metadata->SetTrackNumber((__bridge CFNumberRef)trackNumber);
}

- (NSNumber*)trackTotal
{
    return (__bridge NSNumber*)_metadata->GetTrackTotal();
}

- (void)setTrackTotal:(NSNumber *)trackTotal
{
    _metadata->SetTrackTotal((__bridge CFNumberRef)trackTotal);
}

- (NSNumber*)discNumber
{
    return (__bridge NSNumber*)_metadata->GetDiscNumber();
}

- (void)setDiscNumber:(NSNumber *)discNumber
{
    _metadata->SetDiscNumber((__bridge CFNumberRef)discNumber);
}

- (NSNumber*)discTotal
{
    return (__bridge NSNumber*)_metadata->GetDiscTotal();
}

- (void)setDiscTotal:(NSNumber *)discTotal
{
    _metadata->SetDiscTotal((__bridge CFNumberRef)discTotal);
}

- (NSString*)lyrics
{
    return (__bridge NSString*)_metadata->GetLyrics();
}

- (void)setLyrics:(NSString *)lyrics
{
    _metadata->SetLyrics((__bridge CFStringRef)lyrics);
}

- (NSString*)comment
{
    return (__bridge NSString*)_metadata->GetComment();
}

- (void)setComment:(NSString *)comment
{
    _metadata->SetComment((__bridge CFStringRef)comment);
}

- (NSString*)MCN
{
    return (__bridge NSString*)_metadata->GetMCN();
}

- (void)setMCN:(NSString *)MCN
{
    _metadata->SetMCN((__bridge CFStringRef)MCN);
}

- (NSString*)ISRC
{
    return (__bridge NSString*)_metadata->GetISRC();
}

- (void)setISRC:(NSString *)ISRC
{
    _metadata->SetISRC((__bridge CFStringRef)ISRC);
}

- (NSString*)musicBrainzAlbumID
{
    return (__bridge NSString*)_metadata->GetMusicBrainzReleaseID();
}

- (void)setMusicBrainzAlbumID:(NSString *)musicBrainzAlbumID
{
    _metadata->SetMusicBrainzReleaseID((__bridge CFStringRef)musicBrainzAlbumID);
}

- (NSString*)musicBrainzTrackID
{
    return (__bridge NSString*)_metadata->GetMusicBrainzRecordingID();
}

- (void)setMusicBrainzTrackID:(NSString *)musicBrainzTrackID
{
    _metadata->SetMusicBrainzRecordingID((__bridge CFStringRef)musicBrainzTrackID);
}

#pragma mark -
#pragma mark Additional Metadata

- (NSDictionary*)additionalMetadata
{
    return (__bridge NSDictionary*)_metadata->GetAdditionalMetadata();
}

- (void)setAdditionalMetadata:(NSDictionary *)additionalMetadata
{
    _metadata->SetAdditionalMetadata((__bridge CFDictionaryRef)additionalMetadata);
}

#pragma mark -
#pragma mark Replay Gain

- (NSNumber*)replayGainReferenceLoudness
{
    return (__bridge NSNumber*)_metadata->GetReplayGainReferenceLoudness();
}

- (void)setReplayGainReferenceLoudness:(NSNumber *)replayGainReferenceLoudness
{
    _metadata->SetReplayGainReferenceLoudness((__bridge CFNumberRef)replayGainReferenceLoudness);
}

- (NSNumber*)replayGainTrackGain
{
    return (__bridge NSNumber*)_metadata->GetReplayGainTrackGain();
}

- (void)setReplayGainTrackGain:(NSNumber *)replayGainTrackGain
{
    _metadata->SetReplayGainTrackGain((__bridge CFNumberRef)replayGainTrackGain);
}

- (NSNumber*)replayGainTrackPeak
{
    return (__bridge NSNumber*)_metadata->GetReplayGainTrackPeak();
}

- (void)setReplayGainTrackPeak:(NSNumber *)replayGainTrackPeak
{
    _metadata->SetReplayGainTrackPeak((__bridge CFNumberRef)replayGainTrackPeak);
}

- (NSNumber*)replayGainAlbumGain
{
    return (__bridge NSNumber*)_metadata->GetReplayGainAlbumGain();
}

- (void)setReplayGainAlbumGain:(NSNumber *)replayGainAlbumGain
{
    _metadata->SetReplayGainAlbumGain((__bridge CFNumberRef)replayGainAlbumGain);
}

- (NSNumber*)replayGainAlbumPeak
{
    return (__bridge NSNumber*)_metadata->GetReplayGainAlbumPeak();
}

- (void)setReplayGainAlbumPeak:(NSNumber *)replayGainAlbumPeak
{
    _metadata->SetReplayGainTrackPeak((__bridge CFNumberRef)replayGainAlbumPeak);
}

#pragma mark -
#pragma mark Album Artwork

- (NSData*)frontCoverArtData
{
	auto front = _metadata->GetAttachedPicturesOfType(SFB::Audio::AttachedPicture::Type::FrontCover);
	if (front.size()) {
		auto frontArt = front.at(0);
		return (__bridge NSData*)frontArt->GetData();
	} else {
		auto all = _metadata->GetAttachedPictures();
		if (all.size()) {
			auto art = all.at(0);
			return (__bridge NSData*)art->GetData();
		}
	}
	return nil;
}

- (void)setFrontCoverArtData:(NSData *)frontCoverArtData
{
	/*_metadata->RemoveAttachedPicturesOfType(SFB::Audio::AttachedPicture::Type::FrontCover);
    std::shared_ptr<SFB::Audio::AttachedPicture> picture = new SFB::Audio::AttachedPicture;
	picture->SetType(SFB::Audio::AttachedPicture::Type::FrontCover);
	picture->SetData((__bridge CFDataRef)frontCoverArtData);
	_metadata->AttachPicture(picture);*/
}


@end
