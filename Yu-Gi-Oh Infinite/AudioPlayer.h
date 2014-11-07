//
//  AudioPlayer.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 09/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject

@property (nonatomic) MPMoviePlayerController *audioPlayer;

-(instancetype)initWithBGMusic:(NSString*)name ofExtension:(NSString*)ext;
-(void)setBGMusic:(NSString*)name ofExtension:(NSString*)ext;
-(void)stop;

@end
