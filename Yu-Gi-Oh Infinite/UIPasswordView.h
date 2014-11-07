//
//  UIPasswordView.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 23/02/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMainMenuView.h"

@interface UIPasswordView : UIView <UITextFieldDelegate,UIAlertViewDelegate> {
    CGRect windowFrame;
    
    CGFloat blockStartX;
    CGFloat baseBlockWidth;
    
    UIImageView* BGStarts;
    UIImageView* BGPassword;
    UIImageView* BGButtons;
    UIImageView* cardPlayer;
    
    UITextField* starchipText;
    UITextField* passwordInput;
    UITextField* starCount;
    
    UIButton* tryCode;
    UIButton* backCode;
    
    UIAlertView *buyingAlert;
    UIAlertView *invalidAlert;
    int value;
}

@end
