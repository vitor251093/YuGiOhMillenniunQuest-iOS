//
//  UIMainMenuView.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 13/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UIMainMenuView.h"

@implementation UIMainMenuView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        windowFrame = frame;
        audioPlayer = [[AudioPlayer alloc] initWithBGMusic:@"MainMenuTrack" ofExtension:@"aac"];
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [self loadBGImage:[UIImage imageNamed:@"MainMenuInactive"]];
    [self loadMainMenuButtons];
    [self loadTitleMenuButtons];
    [self addMainMenuButtons];
}
-(void)loadBGImage:(UIImage*)image{
    mainMenuBG = [[UIImageView alloc] initWithFrame:windowFrame];
    [mainMenuBG setImage:image];
    [self addSubview:mainMenuBG];
}
-(void)fadeToView:(SEL)action{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.superview.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [[[NSInvocationOperation alloc] initWithTarget:self selector:action object:nil] start];
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.superview.alpha = 1.0;
                                          }
                                          completion:nil];
                     }];
}

-(void)loadMainMenuButtons{
    NewGameButton = [[UIAncientButton alloc] initWithText:@"NEW GAME" atIndex:1 OfTotal:5 inRect:windowFrame];
    [NewGameButton addTarget:self action:@selector(newGame:) forControlEvents:UIControlEventTouchDown];
    
    LoadGameButton = [[UIAncientButton alloc] initWithText:@"LOAD" atIndex:2 OfTotal:5 inRect:windowFrame];
    [LoadGameButton addTarget:self action:@selector(loadGame:) forControlEvents:UIControlEventTouchDown];
    
    TwoPDuelButton = [[UIAncientButton alloc] initWithText:@"VERSUS" atIndex:3 OfTotal:5 inRect:windowFrame];
    [TwoPDuelButton addTarget:self action:@selector(versusDuel:) forControlEvents:UIControlEventTouchDown];
    
    TradeButton = [[UIAncientButton alloc] initWithText:@"TRADE" atIndex:4 OfTotal:5 inRect:windowFrame];
    [TradeButton addTarget:self action:@selector(trade:) forControlEvents:UIControlEventTouchDown];
    
    OptionsButton = [[UIAncientButton alloc] initWithText:@"OPTIONS" atIndex:5 OfTotal:5 inRect:windowFrame];
    [OptionsButton addTarget:self action:@selector(options:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:NewGameButton];
    [self addSubview:LoadGameButton];
    [self addSubview:TwoPDuelButton];
    [self addSubview:TradeButton];
    [self addSubview:OptionsButton];
}
-(void)addMainMenuButtons{
    [NewGameButton inAnimation];
    [LoadGameButton inAnimation];
    [TwoPDuelButton inAnimation];
    [TradeButton inAnimation];
    [OptionsButton inAnimation];
}
-(void)removeMainMenuButtons{
    [NewGameButton outAnimation];
    [LoadGameButton outAnimation];
    [TwoPDuelButton outAnimation];
    [TradeButton outAnimation];
    [OptionsButton outAnimation];
}

-(void)loadTitleMenuButtons{
    MainMenuButton = [[UIAncientButton alloc] initWithText:@"MAIN MENU" atIndex:1 OfTotal:6 inRect:windowFrame];
    [MainMenuButton addTarget:self action:@selector(mainMenu:) forControlEvents:UIControlEventTouchDown];
    
    CampaignButton = [[UIAncientButton alloc] initWithText:@"CAMPAIGN" atIndex:2 OfTotal:6 inRect:windowFrame];
    [CampaignButton addTarget:self action:@selector(campaign:) forControlEvents:UIControlEventTouchDown];
    
    FreeDuelButton = [[UIAncientButton alloc] initWithText:@"FREE DUEL" atIndex:3 OfTotal:6 inRect:windowFrame];
    [FreeDuelButton addTarget:self action:@selector(freeDuel:) forControlEvents:UIControlEventTouchDown];
    
    BuildDeckButton = [[UIAncientButton alloc] initWithText:@"BUILD DECK" atIndex:4 OfTotal:6 inRect:windowFrame];
    [BuildDeckButton addTarget:self action:@selector(buildDeck:) forControlEvents:UIControlEventTouchDown];
    
    PasswordButton = [[UIAncientButton alloc] initWithText:@"PASSWORD" atIndex:5 OfTotal:6 inRect:windowFrame];
    [PasswordButton addTarget:self action:@selector(password:) forControlEvents:UIControlEventTouchDown];
    
    SaveButton = [[UIAncientButton alloc] initWithText:@"SAVE" atIndex:6 OfTotal:6 inRect:windowFrame];
    [SaveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:MainMenuButton];
    [self addSubview:CampaignButton];
    [self addSubview:FreeDuelButton];
    [self addSubview:BuildDeckButton];
    [self addSubview:PasswordButton];
    [self addSubview:SaveButton];
}
-(void)addTitleMenuButtons{
    [MainMenuButton inAnimation];
    [CampaignButton inAnimation];
    [FreeDuelButton inAnimation];
    [BuildDeckButton inAnimation];
    [PasswordButton inAnimation];
    [SaveButton inAnimation];
}
-(void)removeTitleMenuButtons{
    [MainMenuButton outAnimation];
    [CampaignButton outAnimation];
    [FreeDuelButton outAnimation];
    [BuildDeckButton outAnimation];
    [PasswordButton outAnimation];
    [SaveButton outAnimation];
}

-(void)newGame:(UIButton*)sender{
    gameSave = [[NSGame alloc] initNewGame];
}
-(void)loadGame:(UIButton*)sender{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSGame savePath]]){
        gameSave = [[NSGame alloc] initWithSavedState];
        [self removeMainMenuButtons];
        [self addTitleMenuButtons];
    }
    else{
        NSString* message = @"You don't have any saved state.";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Load Game" message:message delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
-(void)versusDuel:(UIButton*)sender{
    NSString* message = @"Here, you will be able to fight against your friends.";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Versus Mode" message:message delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
} // 0%
-(void)trade:(UIButton*)sender{
    NSString* message = @"Here, you will be able to trade cards with your friends.";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Trade Mode" message:message delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}      // 0%
-(void)options:(UIButton*)sender{
    NSString* message = @"Here, you will be able to adjust the game options.";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Options Window" message:message delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}    // 0%

-(void)mainMenu:(UIButton*)sender{
    gameSave = nil;
    [self removeTitleMenuButtons];
    [self addMainMenuButtons];
}
-(void)campaign:(UIButton*)sender{
    [gameSave campaign];
}   // 0%
-(void)freeDuel:(UIButton*)sender{
    [self removeTitleMenuButtons];
    [self fadeToView:@selector(freeDuelAction)];
}   // 50%
-(void)buildDeck:(UIButton*)sender{
    [self removeTitleMenuButtons];
    [self fadeToView:@selector(buildDeckAction)];
}
-(void)password:(UIButton*)sender{
    [self removeTitleMenuButtons];
    [self fadeToView:@selector(passwordAction)];
}
-(void)save:(UIButton*)sender{
    [gameSave saveGame];
}

-(void)freeDuelAction{
    UIFreeDuelView* freeDuel = [[UIFreeDuelView alloc] initWithFrame:windowFrame];
    [audioPlayer stop];
    [self addSubview:freeDuel];
}
-(void)buildDeckAction{
    UIBuildDeckView* buildDeck = [[UIBuildDeckView alloc] initWithFrame:windowFrame atDuel:NO inFreeDuel:NO];
    [audioPlayer stop];
    [self addSubview:buildDeck];
}
-(void)passwordAction{
    UIPasswordView* PasswordView = [[UIPasswordView alloc] initWithFrame:windowFrame];
    [audioPlayer stop];
    [self addSubview:PasswordView];
}

@end
