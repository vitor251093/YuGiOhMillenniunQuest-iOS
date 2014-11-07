//
//  AudioPlayer.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 09/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

-(instancetype)initWithBGMusic:(NSString*)name ofExtension:(NSString*)ext{
    self = [super init];
    if (self){
        NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:name withExtension:ext];
        self.audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:soundFileURL];
        [self.audioPlayer setShouldAutoplay:YES];
        self.audioPlayer.repeatMode = MPMovieRepeatModeOne;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
        
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [[AVAudioSession sharedInstance] setDelegate:self];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return self;
}

-(void)setBGMusic:(NSString*)name ofExtension:(NSString*)ext{
    NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:name withExtension:ext];
    [self.audioPlayer setContentURL:soundFileURL];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

-(void)stop{
    [self.audioPlayer stop];
}

@end
