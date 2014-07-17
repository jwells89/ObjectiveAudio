//
//  OAArtworkImage.h
//  ObjectiveAudio
//
//  Created by John Wells on 7/17/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OAArtworkImage : NSObject

@property (strong) NSImage *artwork;
@property (strong) NSString *albumTitle;
@property (strong) NSString *artist;

+(instancetype)artworkWithImage:(NSImage *)image albumTitle:(NSString *)albumTitle artist:(NSString *)artist;

@end
