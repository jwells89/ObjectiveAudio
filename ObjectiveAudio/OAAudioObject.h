//
//  OAMetadataDictionary.h
//  ObjectiveAudio
//
//  Created by John Wells on 2/7/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAArtworkImage.h"
#import "OAAudioObjectDelegate.h"

@interface OAAudioObject : NSObject

@property (nonatomic) NSURL *fileURL;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *artist;
@property (nonatomic) NSString *albumTitle;
@property (nonatomic) NSString *albumArtist;
@property (nonatomic, assign) OAArtworkImage *albumArt;
@property (nonatomic) NSInteger trackLength;
@property (nonatomic) NSError *readError;

@property id<OAAudioObjectDelegate> delegate;

@property BOOL isInitialized;
@property BOOL reading;
@property BOOL playingNow;
@property BOOL unreadable;

- (instancetype)initWithURL:(NSURL *)url;

@end
