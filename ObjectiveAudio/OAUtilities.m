//
//  TXUtilities.m
//  TagX
//
//  Created by John Wells on 11/24/13.
//  Copyright (c) 2013 John Wells. All rights reserved.
//

#import "OAUtilities.h"

@implementation OAUtilities

+(NSString *)formatDurationWithSeconds:(int)seconds
{
    NSUInteger h = seconds / 3600;
    NSUInteger m = (seconds / 60) % 60;
    NSUInteger s = seconds % 60;
    
    return h ? [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)h, (unsigned long)m, (unsigned long)s]
    : [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)m, (unsigned long)s];
}

@end
