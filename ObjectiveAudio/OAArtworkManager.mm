//
//  OAArtworkManager.m
//  ObjectiveAudio
//
//  Created by John Wells on 7/13/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "OAArtworkManager.h"
#import <SFBAudioEngine/AudioMetadata.h>
#import "OAArtworkImage.h"
#import "NSImage+MNTImageExtensions.h"

@implementation OAArtworkManager {
    BOOL scaleArt;
}

+(OAArtworkManager *)sharedArtworkManager
{
    static dispatch_once_t once;
    static OAArtworkManager *instance;
    dispatch_once(&once, ^{
        instance = [[OAArtworkManager alloc] init];
        instance.artworkCollection = [NSMutableSet set];
        instance.artworkReadingQueue = [NSOperationQueue new];
        instance.artworkReadingQueue.maxConcurrentOperationCount = 1;
    });
    return instance;
}

-(void)setMaxArtSize:(NSSize)maxArtSize
{
    _maxArtSize = maxArtSize;
    scaleArt = YES;
}

-(void)findOrCreateCoverArtworkForObject:(OAAudioObject *)audioObject image:(NSData *)artworkData;
{
    OAArtworkManager *sharedManager = [OAArtworkManager sharedArtworkManager];
    
    NSBlockOperation *artReadOperation = [NSBlockOperation blockOperationWithBlock:
    ^{
        NSPredicate *matchPredicate = [NSPredicate predicateWithFormat:@"%K = %@ && %K = %@ ", @"albumTitle",
                                       audioObject.albumTitle, @"artist", audioObject.artist];
        
        NSSet *matches = [sharedManager.artworkCollection filteredSetUsingPredicate:matchPredicate];
        
        NSImage *newCover = scaleArt ? [NSImage imageWithData:artworkData] :
                                       [NSImage imageWithData:artworkData cropToSize:self.maxArtSize];
        
        if ([audioObject.albumTitle length] == 0 || [audioObject.artist length] == 0) {
            
            if (!artworkData) { return; }
            
            OAArtworkImage *newArt = [OAArtworkImage artworkWithImage:newCover
                                                           albumTitle:[audioObject.fileURL lastPathComponent]
                                                               artist:nil];
            
            audioObject.albumArt = newArt;
            [sharedManager.artworkCollection addObject:newArt];
            return;
        }
        
        if ([matches count] > 0) {
            OAArtworkImage *matchedArt = [matches allObjects][0];
            
            if (matchedArt.artwork == nil && artworkData) {
                matchedArt.artwork = newCover;
            }
            
            audioObject.albumArt = matchedArt;
        } else {
            OAArtworkImage *newArt = [OAArtworkImage artworkWithImage:newCover
                                                           albumTitle:audioObject.albumTitle
                                                               artist:audioObject.artist];
            audioObject.albumArt = newArt;
            [sharedManager.artworkCollection addObject:newArt];
        }
    }];
    
    [self.artworkReadingQueue addOperation:artReadOperation];
}

@end
