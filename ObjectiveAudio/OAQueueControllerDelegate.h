//
//  OAQueueDelegate.h
//  ObjectiveAudio
//
//  Created by John Wells on 3/3/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OAQueueControllerDelegate <NSObject>

@optional
- (void)queueControllerCurrentSongDidChange:(id)queueController;
- (NSURL *)queueControllerWillEnqueueNextURL:(id)queueController;
- (OAAudioObject *)queueControllerWillEnqueueNextObject:(id)queueController;
- (OAAudioObject *)queueControllerWillEnqueuePreviousObject:(id)queueController;

@end
