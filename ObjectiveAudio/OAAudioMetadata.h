//
//  OAAudioMetadata.h
//  ObjectiveAudio
//
//  Created by John Wells on 7/16/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAAudioObject.h"

@interface OAAudioMetadata : NSObject

@property (nonatomic, readonly) NSString *formatName;
@property (nonatomic, readonly) NSNumber *totalFrames;
@property (nonatomic, readonly) NSNumber *channelsPerFrame;
@property (nonatomic, readonly) NSNumber *bitsPerChannel;
@property (nonatomic, readonly) NSNumber *sampleRate;
@property (nonatomic, readonly) NSNumber *duration;
@property (nonatomic, readonly) NSNumber *bitrate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *albumTitle;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *albumArtist;
@property (nonatomic, retain) NSString *genre;
@property (nonatomic, retain) NSString *composer;
@property (nonatomic, retain) NSString *releaseDate;
@property (nonatomic, retain) NSNumber *compilation;
@property (nonatomic, retain) NSNumber *trackNumber;
@property (nonatomic, retain) NSNumber *trackTotal;
@property (nonatomic, retain) NSNumber *discNumber;
@property (nonatomic, retain) NSNumber *discTotal;
@property (nonatomic, retain) NSString *lyrics;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *MCN;
@property (nonatomic, retain) NSString *ISRC;
@property (nonatomic, retain) NSString *musicBrainzAlbumID;
@property (nonatomic, retain) NSString *musicBrainzTrackID;

@property (nonatomic, retain) NSDictionary *additionalMetadata;

@property (nonatomic, retain) NSNumber *replayGainReferenceLoudness;
@property (nonatomic, retain) NSNumber *replayGainTrackGain;
@property (nonatomic, retain) NSNumber *replayGainTrackPeak;
@property (nonatomic, retain) NSNumber *replayGainAlbumGain;
@property (nonatomic, retain) NSNumber *replayGainAlbumPeak;

@property (nonatomic, retain) NSData *frontCoverArtData;

-(instancetype)initWithFileAtURL:(NSURL *)fileURL;
-(instancetype)initWithAudioObject:(OAAudioObject *)audioObject;

@end
