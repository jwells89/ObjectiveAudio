//
//  OAAudioMetadata.m
//  ObjectiveAudio
//
//  Created by John Wells on 2/7/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//
//  Based on Matt Gemmel's MGCropExtensions

#import <Cocoa/Cocoa.h>

@interface NSImage (MNTImageExtensions)

typedef enum {
    MGImageResizeCrop,
    MGImageResizeCropStart,
    MGImageResizeCropEnd,
    MGImageResizeScale
} MGImageResizingMethod;

- (void)drawInRect:(NSRect)dstRect operation:(NSCompositingOperation)op fraction:(float)delta method:(MGImageResizingMethod)resizeMethod;
+ (NSImage *)imageWithData:(NSData *)imageData;
+ (NSImage *)imageWithData:(NSData *)imageData cropToSize:(NSSize)size;
- (NSImage *)imageToFitSize:(NSSize)size method:(MGImageResizingMethod)resizeMethod;
- (NSImage *)imageCroppedToFitSize:(NSSize)size;
- (NSImage *)imageScaledToFitSize:(NSSize)size;

@end