//
//  OAAudioPlayerDelegate.h
//  ObjectiveAudio
//
//  Created by John Wells on 2/7/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OAAudioObject;
@protocol OAAudioPlayerDelegate <NSObject>

@optional
- (void)audioPlayerSongWillChange:(id)player;
- (void)audioPlayerSongDidChange:(id)player;
- (void)audioPlayerStateDidChange:(id)player;
- (void)audioPlayerVolumeDidChange:(id)player;
- (void)audioPlayerPositionDidChange:(id)player;

@end
