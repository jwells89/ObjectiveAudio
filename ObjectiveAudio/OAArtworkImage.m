//
//  OAArtworkImage.m
//  ObjectiveAudio
//
//  Created by John Wells on 7/17/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "OAArtworkImage.h"

@implementation OAArtworkImage

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.artwork = [coder decodeObjectForKey:@"artwork"];
        self.albumTitle = [coder decodeObjectForKey:@"albumTitle"];
        self.artist = [coder decodeObjectForKey:@"artist"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.artwork forKey:@"artwork"];
    [aCoder encodeObject:self.albumTitle forKey:@"albumTitle"];
    [aCoder encodeObject:self.artist forKey:@"artist"];
}

+(instancetype)artworkWithImage:(NSImage *)image albumTitle:(NSString *)albumTitle artist:(NSString *)artist
{
    OAArtworkImage *newArt = [[OAArtworkImage alloc] init];
    
    newArt.artwork = image;
    newArt.albumTitle = albumTitle;
    newArt.artist = artist;
    
    return newArt;
}

@end
