//
//  OAQueueController.m
//  ObjectiveAudio
//
//  Created by John Wells on 3/3/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "OAQueueController.h"

@implementation OAQueueController

-(void)setCurrentObject:(OAAudioObject *)currentObject
{
    [self willChangeValueForKey:@"currentObject"];
    _currentObject = currentObject;
   // [self.delegate queueControllerCurrentSongDidChange:self];
    [self didChangeValueForKey:@"currentObject"];
}

-(OAAudioObject *)nextObject
{
    [self willChangeValueForKey:@"nextObject"];
    if (_nextObject == _currentObject || _nextObject == nil) {
        _nextObject = [self loadNextObject];
    }
    [self didChangeValueForKey:@"nextObject"];
    
    return _nextObject;
}

-(OAAudioObject *)loadNextObject
{
    if (!self.loadingNext) {
        OAAudioObject       *nextObject;
        OAQueueController   *queueController = self;
        id                   delegate        = self.delegate;
        
        nextObject = [delegate queueControllerWillEnqueueNextObject:queueController];
        
        return nextObject;
    }
    
    return nil;
}

@end
