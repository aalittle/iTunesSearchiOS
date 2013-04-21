//
//  ALTweet.m
//  iTunesSearchiOS
//
//  Created by Andrew Little on 2013-04-21.
//  Copyright (c) 2013 Andrew Little. All rights reserved.
//

#import "ALMusicTrack.h"

@implementation ALMusicTrack

-(NSString *)description {
    
    return [NSString stringWithFormat:@"artist id: %@, artist name: %@, song name: %@", [self.artistId stringValue], self.artistName, self.trackName];
}


@end
