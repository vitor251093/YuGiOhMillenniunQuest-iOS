//
//  UIDuelGroundView.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 27/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UIDuelView.h"

@implementation UIDuelView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        windowFrame = frame;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame withDuelist:(int)duelist atFreeDuel:(BOOL)freeDuel{
    self = [self initWithFrame:frame];
    if (self){
        NSArray* duelists = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Duelists" withExtension:@"plist"]];
        opponent = [duelists objectAtIndex:duelist];
        isFreeDuel = freeDuel;
    }
    return self;
}

-(UIButton*)generateButtonAt:(CGRect)position withTitle:(NSString*)title{
    UIButton* result = [[UIButton alloc] initWithFrame:position];
    [result setTitle:title forState:UIControlStateNormal];
    [result setTitle:title forState:UIControlStateHighlighted];
    [result setUserInteractionEnabled:TRUE];
    [result setEnabled:TRUE];
    return result;
}
-(void)generateReturnButton{
    UIButton* returnButton = [self generateButtonAt:CGRectMake(40, 40, windowFrame.size.width/4, windowFrame.origin.y-20) withTitle:@"Back"];
    int widthText = [UIUtilities widthOfString:@"Back" withFont:[[returnButton titleLabel] font]];
    [returnButton setFrame:CGRectMake(returnButton.frame.origin.x,returnButton.frame.origin.y,
                                      widthText*1.1,returnButton.frame.size.height)];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [returnButton addTarget:self action:@selector(finishDuel:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:returnButton];
}

-(void)startDuel{
    [audioPlayer stop];
    //fieldView = [[UIDuelFieldView alloc] initWithFrame:windowFrame];
    glFieldView = [[GLDuelFieldView alloc] initWithFrame:windowFrame];
    [self addSubview:glFieldView];
    
    [self generateReturnButton];
}
-(void)finishDuel:(UIButton*)sender{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.superview.superview.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         self.alpha = 0.0;
                         if (isFreeDuel) [audioPlayer setBGMusic:@"FreeDuelTrack" ofExtension:@"mp3"];
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.superview.superview.alpha = 1.0;
                                              [self removeFromSuperview];
                                          }
                                          completion:nil];
                     }];
}

-(void)drawRect:(CGRect)rect{
    UIBuildDeckView* nextView = [[UIBuildDeckView alloc] initWithFrame:windowFrame atDuel:YES inFreeDuel:isFreeDuel];
    [audioPlayer stop];
    [self addSubview:nextView];
}


@end
