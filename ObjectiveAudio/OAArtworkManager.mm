//
//  OAArtworkManager.m
//  ObjectiveAudio
//
//  Created by John Wells on 7/13/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "OAArtworkManager.h"
#import <SFBAudioEngine/AudioMetadata.h>
#import "OAArtworkImage.h"
#import "NSImage+MNTImageExtensions.h"

@implementation NSString (OAAdditions)

-(NSString *)MD5String
{
	NSData* inputData = [self dataUsingEncoding:NSUTF8StringEncoding];
	unsigned char outputData[CC_MD5_DIGEST_LENGTH];
	CC_MD5([inputData bytes], (unsigned int)[inputData length], outputData);
	
	NSMutableString* hashStr = [NSMutableString string];
	int i = 0;
	for (i = 0; i < CC_MD5_DIGEST_LENGTH; ++i)
		[hashStr appendFormat:@"%02x", outputData[i]];
	
	return hashStr;
}

@end

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

-(void)findOrCreateCoverArtworkForObject:(OAAudioObject *)audioObject imageData:(NSData *)artworkData;
{
    OAArtworkManager *sharedManager = [OAArtworkManager sharedArtworkManager];
    
    NSBlockOperation *artReadOperation = [NSBlockOperation blockOperationWithBlock:
    ^{
        NSPredicate *matchPredicate = [NSPredicate predicateWithFormat:@"%K = %@ && %K = %@ ", @"albumTitle",
                                       audioObject.albumTitle, @"artist", audioObject.artist];
        
        NSSet *matches = [sharedManager.artworkCollection filteredSetUsingPredicate:matchPredicate];
        
        NSImage *newCover = scaleArt ? [NSImage imageWithData:artworkData cropToSize:self.maxArtSize] :
                                       [NSImage imageWithData:artworkData];
        
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

-(void)findCoverArtworkForObject:(OAAudioObject *)audioObject
{
    OAArtworkManager *sharedManager = [OAArtworkManager sharedArtworkManager];
    
    NSBlockOperation *artReadOperation = [NSBlockOperation blockOperationWithBlock:
      ^{
          NSPredicate *matchPredicate = [NSPredicate predicateWithFormat:@"%K = %@ && %K = %@ ", @"albumTitle",
                                         audioObject.albumTitle, @"artist", audioObject.artist];
          
          NSSet *matches = [sharedManager.artworkCollection filteredSetUsingPredicate:matchPredicate];
          
          if ([matches count] > 0) {
              OAArtworkImage *matchedArt = [matches allObjects][0];
              
              audioObject.albumArt = matchedArt;
          }
      }];
    
    [self.artworkReadingQueue addOperation:artReadOperation];

}

-(void)loadArtCollectionFromDirectory:(NSString *)filePath
{
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
    
    for (NSString *file in files) {
        if ([file hasSuffix:@"artstore"]) {
            NSString *artPath = [filePath stringByAppendingPathComponent:file];
            OAArtworkImage *archivedArt = [NSKeyedUnarchiver unarchiveObjectWithFile:artPath];
            
            if (archivedArt) {
                [self.artworkCollection addObject:archivedArt];
            }
        }
    }
}

-(void)writeArtCollectionToDirectory:(NSString *)filePath
{
    for (OAArtworkImage *a in [[OAArtworkManager sharedArtworkManager] artworkCollection]) {
        NSString *combinedString = [a.artist stringByAppendingString:a.albumTitle];
        NSString *hash = [combinedString MD5String];
        
        NSString *artPath = [NSString stringWithFormat:@"%@.artstore", [filePath stringByAppendingPathComponent:hash]];
        
        [NSKeyedArchiver archiveRootObject:a toFile:artPath];
    }
    
}

@end

