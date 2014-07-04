//
//  OAAudioMetadata.h
//  ObjectiveAudio
//
//  Created by John Wells on 2/7/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAAudioObject.h"

@interface OAFileManager : NSObject

+ (NSArray *)supportedFormats;
+ (OAAudioObject *)objectForURL:(NSURL *)url;
+ (NSArray *)objectsForURLs:(NSArray *)urlArray;

@end
