//
//  OAAudioObjectDelegate.h
//  ObjectiveAudio
//
//  Created by John Wells on 7/31/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OAAudioObjectDelegate <NSObject>

@optional

-(void)audioObject:(id)sender didChangeKey:(NSString *)key;

@end
