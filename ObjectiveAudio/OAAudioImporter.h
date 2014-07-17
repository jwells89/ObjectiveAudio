//
//  OAAudioImporter.h
//  ObjectiveAudio
//
//  Created by John Wells on 7/16/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAAudioObject.h"

@interface OAAudioImporter : NSObject

@property (strong) NSOperationQueue *importQueue;

- (void)importMetadataForAudioObject:(OAAudioObject *)audioObject;

@end
