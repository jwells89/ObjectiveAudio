//
//  OAQueueController.h
//  ObjectiveAudio
//
//  Created by John Wells on 3/3/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAAudioObject.h"
#import "OAQueueControllerDelegate.h"

@interface OAQueueController : NSObject

@property (nonatomic) IBOutlet id<OAQueueControllerDelegate> delegate;
@property (nonatomic) OAAudioObject *currentObject;
@property (nonatomic) OAAudioObject *nextObject;
@property (nonatomic) BOOL loadingNext;
@property (nonatomic) OAAudioObject *previousObject;
@property (nonatomic) BOOL loadingPrevious;


@end
