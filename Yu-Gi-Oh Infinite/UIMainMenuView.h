//
//  UIMainMenuView.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 13/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtilities.h"
#import "UIAncientButton.h"
#import "UIPasswordView.h"
#import "UIBuildDeckView.h"
#import "UIFreeDuelView.h"

#import "UIDuelView.h"

@interface UIMainMenuView : UIView <UIAlertViewDelegate>{
    UIImageView* mainMenuBG;
    CGRect windowFrame;
    
    UIAncientButton* NewGameButton;
    UIAncientButton* LoadGameButton;
    UIAncientButton* TwoPDuelButton;
    UIAncientButton* TradeButton;
    UIAncientButton* OptionsButton;
    
    UIAncientButton* MainMenuButton;
    UIAncientButton* CampaignButton;
    UIAncientButton* FreeDuelButton;
    UIAncientButton* BuildDeckButton;
    UIAncientButton* PasswordButton;
    UIAncientButton* SaveButton;
}

-(void)addMainMenuButtons;
-(void)removeMainMenuButtons;
-(void)addTitleMenuButtons;
-(void)removeTitleMenuButtons;

@end
