//
//  NSAncientButton.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 23/02/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UIAncientButton.h"
#import "UIUtilities.h"

#define BASE_WINDOW_HEIGHT 320
#define BASE_WINDOW_WIDTH 480
#define BASE_BUTTON_HEIGHT 37
#define BASE_BUTTON_WIDTH 42

@implementation UIAncientButton

-(instancetype)initWithText:(NSString*)text atIndex:(int)index OfTotal:(int)total inRect:(CGRect)screenRect{
    self = [super init];
    if (self){
        //Button Text Fonts
        littleText = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:(20*screenRect.size.height)/BASE_WINDOW_HEIGHT];
        bigText = [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:(22*screenRect.size.height)/BASE_WINDOW_HEIGHT];
        self.titleLabel.font = littleText;
        
        //Button Background
        CGFloat scale = (0.5*screenRect.size.height)/320;
        inactiveImage = [UIImage imageNamed:@"ButtonInactive"];
        activeImage = [UIImage imageNamed:@"ButtonActive"];
        inactiveImage = [UIUtilities imageWithImage:inactiveImage scaledRate:scale];
        activeImage = [UIUtilities imageWithImage:activeImage scaledRate:scale];
        inactiveImage = [UIUtilities insertCapInsetsIn:inactiveImage];
        activeImage = [UIUtilities insertCapInsetsIn:activeImage];
        [self setBackgroundImage:inactiveImage forState:UIControlStateNormal];
        [self setBackgroundImage:activeImage forState:UIControlStateHighlighted];
        
        //Button Text Color
        UIColor* inactiveColor = [UIColor colorWithRed:136/255.0 green:126/255.0 blue:130/255.0 alpha:1.0];
        UIColor* activeColor = [UIColor colorWithRed:147/255.0 green:225/255.0 blue:148/255.0 alpha:1.0];
        [self setTitleColor:inactiveColor forState:UIControlStateNormal];
        [self setTitleColor:activeColor forState:UIControlStateHighlighted];
        
        //Button Size and Position
        width = [UIUtilities widthOfString:text withFont:littleText]+(BASE_BUTTON_WIDTH*screenRect.size.width)/BASE_WINDOW_WIDTH;
        height = (BASE_BUTTON_HEIGHT*screenRect.size.height)/BASE_WINDOW_HEIGHT;
        x = (screenRect.size.width - width)/2;
        y = ((20*(2*index - total) + 121)*screenRect.size.height)/BASE_WINDOW_HEIGHT;
        
        itemIndex = index;
        movingLenght = (1000*screenRect.size.width)/BASE_WINDOW_WIDTH;
        if (index%2==1) x-=movingLenght;
        else x+=movingLenght;
        [self setFrame:CGRectMake(x,y,width,height)];
        
        //Button Text
        [self setTitle:text forState:UIControlStateNormal];
        [self setTitle:text forState:UIControlStateHighlighted];
    }
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    [UIUtilities playSound:@"selectAction" ofType:@"wav"];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
    [super touchesEnded:touches withEvent:event];
}

-(void)inAnimation{
    [self setBackgroundImage:inactiveImage forState:UIControlStateNormal];
    [self setFrame:CGRectMake(x,y,width,height)];
    self.titleLabel.font = littleText;
    CGFloat duration = 0.7;
    
    if (itemIndex%2==1) x+=movingLenght;
    else x-=movingLenght;
    
    [UIView animateWithDuration:duration
                     animations:^{self.frame = CGRectMake(x,y,width,height);}
                     completion:nil];
}
-(void)outAnimation{
    CGFloat duration = 0.7;
    
    if (itemIndex%2==0) x+=movingLenght;
    else x-=movingLenght;
    
    [UIView animateWithDuration:duration
                     animations:^{self.frame = CGRectMake(x,y,width,height);}
                     completion:nil];
}

@end
