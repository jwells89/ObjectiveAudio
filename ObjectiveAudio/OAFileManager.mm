//
//  OAAudioMetadata.m
//  ObjectiveAudio
//
//  Created by John Wells on 2/7/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "OAFileManager.h"
#import <SFBAudioEngine/AudioMetadata.h>
#import <SFBAudioEngine/AudioDecoder.h>

@implementation OAFileManager

+(OAAudioObject *)objectForURL:(NSURL *)url
{
    OAAudioObject *dictionary = [[OAAudioObject alloc] initWithURL:url];
    
    return dictionary;
}

+(NSArray *)objectsForURLs:(NSArray *)urlArray
{
    NSMutableArray *metadataArray = [[NSMutableArray alloc] init];
    
    for (NSURL * u in urlArray) {
        OAAudioObject *dictionary = [OAFileManager objectForURL:u];
        
        [metadataArray addObject:dictionary];
    }
    
    return metadataArray;
}

+(NSArray *)supportedFormats
{
    return (__bridge_transfer NSArray *)SFB::Audio::Decoder::CreateSupportedFileExtensions();
}

@end
