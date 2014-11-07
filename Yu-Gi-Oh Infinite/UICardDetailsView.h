//
//  UICardDetailsView.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 18/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSCard.h"
#import "UIUtilities.h"

@interface UICardDetailsView : UIView{
    CGRect windowFrame;
    CGFloat blockStartX;
    CGFloat baseBlockWidth;
    
    NSCard* playerCard;
    
    UIImageView* cardPlayer;
    UIImageView* BGType;
    UIImageView* BGGuardianStar;
    UIImageView* BGDescription;
    
    UIImageView* typeIcon;
    UITextField* typeText;
    UITextField* guardianStarText;
    UIImageView* guardianStarOneIcon;
    UITextField* guardianStarOneText;
    UIImageView* guardianStarTwoIcon;
    UITextField* guardianStarTwoText;
    UITextView* descriptionText;
    
    UIButton* okButton;
}

- (id)initWithFrame:(CGRect)frame andCard:(NSCard*)card;

@end
