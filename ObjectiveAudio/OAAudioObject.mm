//
//  OAMetadataDictionary.m
//  ObjectiveAudio
//
//  Created by John Wells on 2/7/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "OAAudioObject.h"

@implementation OAAudioObject

-(id)initWithURL:(NSURL *)url
{
    self = [self init];
    
    _fileURL = url;
    
    return self;
}

-(NSInteger)trackLength
{
  /*
    if (self.unreadable) {
        return nil;
    }
    
    if (_metadata->GetTotalFrames() && _metadata->GetSampleRate()) {
        NSNumber *totalFrames = (__bridge NSNumber *)_metadata->GetTotalFrames();
        NSNumber *sampleRate = (__bridge NSNumber *)_metadata->GetSampleRate();
        
        return [totalFrames integerValue]/[sampleRate integerValue];
    }
    */
    return nil;
}

@end
