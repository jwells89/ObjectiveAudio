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

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        self.fileURL = [coder decodeObjectForKey:@"fileURL"];
        self.title = [coder decodeObjectForKey:@"title"];
        self.artist = [coder decodeObjectForKey:@"artist"];
        self.albumTitle = [coder decodeObjectForKey:@"albumTitle"];
        self.albumArtist = [coder decodeObjectForKey:@"albumArtist"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.fileURL forKey:@"fileURL"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.artist forKey:@"artist"];
    [aCoder encodeObject:self.albumTitle forKey:@"albumTitle"];
    [aCoder encodeObject:self.albumArtist forKey:@"albumArtist"];
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    [self.delegate audioObject:self didChangeKey:@"title"];
}

-(void)setArtist:(NSString *)artist
{
    _artist = artist;
    [self.delegate audioObject:self didChangeKey:@"artist"];
}

-(void)setAlbumTitle:(NSString *)albumTitle
{
    _albumTitle = albumTitle;
    [self.delegate audioObject:self didChangeKey:@"albumTitle"];
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
