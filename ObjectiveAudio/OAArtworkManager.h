//
//  OAArtworkManager.h
//  ObjectiveAudio
//
//  Created by John Wells on 7/13/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAAudioObject.h"

@interface OAArtworkManager : NSObject

@property (strong) NSMutableSet *artworkCollection;
@property (strong) NSImage      *coverPlaceholder;
@property (strong) NSOperationQueue *artworkReadingQueue;
@property (nonatomic) NSSize maxArtSize;

+(OAArtworkManager *)sharedArtworkManager;
-(void)findOrCreateCoverArtworkForObject:(OAAudioObject *)audioObject imageData:(NSData *)artworkData;
-(void)findCoverArtworkForObject:(OAAudioObject *)audioObject;
-(void)loadArtCollectionFromDirectory:(NSString *)filePath;
-(void)writeArtCollectionToDirectory:(NSString *)filePath;

@end
