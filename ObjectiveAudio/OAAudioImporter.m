//
//  OAAudioImporter.m
//  ObjectiveAudio
//
//  Created by John Wells on 7/16/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "OAAudioImporter.h"
#import "OAAudioMetadata.h"
#import "OAArtworkManager.h"

@implementation OAAudioImporter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _importQueue = [NSOperationQueue new];
        _importQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

-(void)importMetadataForAudioObject:(OAAudioObject *)audioObject
{
    NSBlockOperation *metadataImportOperation = [NSBlockOperation blockOperationWithBlock:^{
        OAAudioMetadata *metadata = [[OAAudioMetadata alloc] initWithAudioObject:audioObject];
        
        if (!metadata) {
            return;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            audioObject.title = ([metadata.title length] != 0) ? metadata.title : [audioObject.fileURL lastPathComponent];
            audioObject.albumTitle  = metadata.albumTitle;
            audioObject.artist = metadata.artist;
            audioObject.trackLength = [metadata.duration integerValue];
            //audioObject.albumArt = [[NSImage alloc] initWithData:metadata.frontCoverArtData];
        });
        
        [[OAArtworkManager sharedArtworkManager] findOrCreateCoverArtworkForObject:audioObject image:metadata.frontCoverArtData];
    }];
    
    [self.importQueue addOperation:metadataImportOperation];
}

@end
