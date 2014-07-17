//
//  OAArtworkImage.m
//  ObjectiveAudio
//
//  Created by John Wells on 7/17/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "OAArtworkImage.h"

@implementation OAArtworkImage

+(instancetype)artworkWithImage:(NSImage *)image albumTitle:(NSString *)albumTitle artist:(NSString *)artist
{
    OAArtworkImage *newArt = [[OAArtworkImage alloc] init];
    
    newArt.artwork = image;
    newArt.albumTitle = albumTitle;
    newArt.artist = artist;
    
    return newArt;
}

@end
