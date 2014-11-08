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
        [self playBGMusic:name ofExtension:ext];
    }
    return self;
}

//If you’re playing background music, you should check to see if other audio (like the iPod) is playing first, so you don’t have two layers of music going on at once!
//If a phone call arrives and the user chooses “Decline,” by default your AVAudioPlayer will stop. You can start it back up again by registering for the AVAudioPlayerDelegate and resuming music in the audioPlayerEndInterruption:withOptions method.

-(void)setBGMusic:(NSString*)name ofExtension:(NSString*)ext{
    [self.backgroundMusicPlayer stop];
    [self playBGMusic:name ofExtension:ext];
}

-(void)playBGMusic:(NSString*)name ofExtension:(NSString*)ext{
    NSError *error;
    NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:name withExtension:ext];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:&error];
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    if (error) NSLog(@"%@",error);
}
-(void)stop{
    [self.audioPlayer stop];
}

@end
