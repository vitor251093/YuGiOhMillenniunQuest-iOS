//
//  NSAncientButton.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 23/02/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAncientButton : UIButton{
    UIImage *inactiveImage;
    UIImage *activeImage;
    
    CGFloat height;
    CGFloat width;
    CGFloat x;
    CGFloat y;
    
    UIFont* littleText;
    UIFont* bigText;
    
    CGFloat movingLenght;
    int itemIndex;
}

-(instancetype)initWithText:(NSString*)text atIndex:(int)index OfTotal:(int)total inRect:(CGRect)screenRect;

-(void)inAnimation;
-(void)outAnimation;

@end
