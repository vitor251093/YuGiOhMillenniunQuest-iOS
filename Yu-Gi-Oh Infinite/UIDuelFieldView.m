//
//  UIDuelFieldView.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 11/04/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UIDuelFieldView.h"

@implementation UIDuelFieldView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        windowFrame = frame;
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [[UIColor whiteColor] setStroke];
    field = [[UI3DField alloc] initWithFrame:windowFrame];
    [field setPerspectiveCenter:CG3DPointMake(windowFrame.size.width/2, 0, 1500)];
    [field setPerspective:1500];
    [field setView:self];
    [field updateUI];
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:0.001 target:field selector:@selector(reducePerspective:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

@end