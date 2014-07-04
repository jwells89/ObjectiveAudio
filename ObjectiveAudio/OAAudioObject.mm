//
//  OAMetadataDictionary.m
//  ObjectiveAudio
//
//  Created by John Wells on 2/7/14.
//  Copyright (c) 2014 John Wells. All rights reserved.
//

#import "OAAudioObject.h"
#import <SFBAudioEngine/AudioMetadata.h>

@implementation OAAudioObject {
    std::unique_ptr<SFB::Audio::Metadata> _metadata;
}

-(id)initWithURL:(NSURL *)url
{
    self = [self init];
    
    _fileURL = url;
    _reading = NO;
    
    return self;
}

-(void)setMetadata:(std::unique_ptr<SFB::Audio::Metadata>)metadata
{
    _metadata = std::move(metadata);
}

-(BOOL)initialize
{
    OAAudioObject *object = self;

    object.reading = YES;
    [object setMetadata:SFB::Audio::Metadata::CreateMetadataForURL((__bridge CFURLRef)self.fileURL)];
    
    if (_metadata != nullptr) {
        object.reading = NO;
        object.isInitialized = YES;
        return YES;
    }
    
    object.reading = NO;
    object.unreadable = YES;
    object.isInitialized = YES;
    return NO;
}

-(NSString *)title
{
    if (!self.isInitialized) {
        [self initialize];
    }
    
    if (!self.unreadable) {
        NSString *title = (__bridge NSString *)_metadata->GetTitle();
        
        return [title isNotEqualTo:@""] ? title : [self.fileURL lastPathComponent];
    }
    
    return @"Unreadable";
}

-(NSString *)artist
{
    if (!self.isInitialized) {
        [self initialize];
    }
    
    if (!self.unreadable) {
        NSString *artist = (__bridge NSString *)_metadata->GetArtist();
        
        return [artist isNotEqualTo:@""] ? artist : @"Unknown Artist";
    }
    
    return @"Unreadable";
}

-(NSString *)albumTitle
{
    if (!self.isInitialized) {
        [self initialize];
    }
    
    if (!self.unreadable) {
        NSString *album = (__bridge NSString *)_metadata->GetAlbumTitle();
        
        return [album isNotEqualTo:@""] ? album : @"Unknown Album";
    }
    
    return @"Unreadable";
}

-(NSString *)albumArtist
{
    if (!self.isInitialized) {
        [self initialize];
    }
    
    if (!self.unreadable) {
        return _metadata->GetAlbumArtist() ? (__bridge NSString *)_metadata->GetAlbumArtist() : nil;
    }
    
    return nil;
}

-(NSImage *)albumArt
{
    if (_metadata == nullptr) {
        [self initialize];
    }
    
    if (self.unreadable) {
        return nil;
    }
    
    if (!_albumArt) {
        [self willChangeValueForKey:@"albumArt"];
        if(!_metadata->GetAttachedPictures().empty()){
            _albumArt = [[NSImage alloc] initWithData:(__bridge NSData *)_metadata->GetAttachedPictures().front()->GetData()];
            
        } else {
            _albumArt = [[NSImage alloc] init];
        }
        [self didChangeValueForKey:@"albumArt"];
    }
    
    
    return _albumArt;
}

-(NSInteger)trackLength
{
    if (!self.isInitialized) {
        [self initialize];
    }
    
    if (self.unreadable) {
        return nil;
    }
    
    if (_metadata->GetTotalFrames() && _metadata->GetSampleRate()) {
        NSNumber *totalFrames = (__bridge NSNumber *)_metadata->GetTotalFrames();
        NSNumber *sampleRate = (__bridge NSNumber *)_metadata->GetSampleRate();
        
        return [totalFrames integerValue]/[sampleRate integerValue];
    }
    
    return nil;
}

@end
