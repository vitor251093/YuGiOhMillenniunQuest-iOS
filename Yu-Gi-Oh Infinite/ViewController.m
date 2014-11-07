//
//  ViewController.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 23/02/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    frame = self.view.frame;
    CGFloat startButtonW = frame.size.height;
    CGFloat startButtonH = frame.size.width;
    frame = CGRectMake(0,0,startButtonW,startButtonH);
    
    playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[[NSBundle mainBundle] URLForResource:@"opening" withExtension:@"mp4"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object:[playerViewController moviePlayer]];
    [self.view addSubview:playerViewController.view];
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    [player setScalingMode:MPMovieScalingModeFill];
    player.controlStyle=MPMovieControlStyleNone;
    [player play];
    
    startButton = [[UIButton alloc] initWithFrame:frame];
    [startButton addTarget:nil action:@selector(movieFinishedCallback:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:startButton];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)movieFinishedCallback:(NSNotification*)aNotification{
    [startButton removeFromSuperview];
    MPMoviePlayerController *player = [playerViewController moviePlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
	[player.view removeFromSuperview];
    
    mainMenuView = [[UIMainMenuView alloc] initWithFrame:frame];
    [self.view addSubview:mainMenuView];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
