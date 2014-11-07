//
//  UIPasswordView.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 23/02/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UIPasswordView.h"
#import "NSCard.h"
#import "UIUtilities.h"

@implementation UIPasswordView

-(void)showMessage:(NSString*)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Buying Card" message:message delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void)showInvalidMessage:(NSString*)message{
    invalidAlert = [[UIAlertView alloc] initWithTitle:@"Buying Card" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [invalidAlert show];
}

-(void)calculateBaseBlockWidth{
    CGRect card = cardPlayer.frame;
    blockStartX = card.origin.x*2 + card.size.width;
    baseBlockWidth = windowFrame.size.width - card.origin.x - blockStartX;
}
-(CGRect)generateRectOf:(CGRect)position{
    CGFloat x = blockStartX + (position.origin.x*baseBlockWidth)/480;
    CGFloat y = windowFrame.origin.y + (position.origin.y*windowFrame.size.height)/320;
    CGFloat w = (baseBlockWidth*position.size.width)/480;
    CGFloat h = (position.size.height*windowFrame.size.height)/320;
    return CGRectMake(x,y,w,h);
}
-(UITextField*)generateTextFieldAt:(CGRect)position{
    CGRect newPos = [self generateRectOf:position];
    UITextField* result = [[UITextField alloc] initWithFrame:newPos];
    [result setTextColor:[UIColor whiteColor]];
    [result adjustsFontSizeToFitWidth];
    return result;
}
-(UIButton*)generateButtonAt:(CGRect)position withTitle:(NSString*)title{
    CGRect newPos = [self generateRectOf:position];
    UIButton* result = [[UIButton alloc] initWithFrame:newPos];
    [result setTitle:title forState:UIControlStateNormal];
    [result setTitle:title forState:UIControlStateHighlighted];
    [result setUserInteractionEnabled:TRUE];
    [result setEnabled:TRUE];
    return result;
}

-(void)initCard{
    CGFloat x = (10*windowFrame.size.width)/480;
    CGFloat y = windowFrame.origin.y + windowFrame.size.height/2-(315*windowFrame.size.height)/666;
    CGFloat h = (300*windowFrame.size.height)/320;
    CGFloat w = (h*419)/610;
    
    cardPlayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FaceDown"]];
    [cardPlayer setFrame:CGRectMake(x,y,w,h)];
    [self addSubview:cardPlayer];
}
-(void)loadCard:(UIImage*)card{
    [UIUtilities playSound:@"flipCard" ofType:@"wav"];
    [UIView transitionWithView:cardPlayer duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                           cardPlayer.image = card;
                       } completion:nil];
}
-(void)loadBackground{
    CGFloat scale = (0.3*windowFrame.size.height)/320;
    UIImage *passwordFrame = [UIImage imageNamed:@"passwordFrame"];
    passwordFrame = [UIUtilities imageWithImage:passwordFrame scaledRate:scale];
    passwordFrame = [UIUtilities insertCapInsetsIn:passwordFrame];
    
    BGStarts = [[UIImageView alloc] initWithFrame:[self generateRectOf:CGRectMake(0,8,480,75)]];
    [BGStarts setImage:passwordFrame];
    [self addSubview:BGStarts];
    
    BGPassword = [[UIImageView alloc] initWithFrame:[self generateRectOf:CGRectMake(0,83,480,105)]];
    [BGPassword setImage:passwordFrame];
    [self addSubview:BGPassword];
    
    BGButtons = [[UIImageView alloc] initWithFrame:[self generateRectOf:CGRectMake(0,188,480,121)]];
    [BGButtons setImage:passwordFrame];
    [self addSubview:BGButtons];
}
-(void)loadTextFields{
    starchipText = [self generateTextFieldAt:CGRectMake(30,5,480,53)];
    starchipText.font = [UIFont fontWithName:@"Copperplate" size:(30*windowFrame.size.height)/320];
    [starchipText setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0]];
    [starchipText setEnabled:FALSE];
    [starchipText setText:@"STARCHIP"];
    [self addSubview:starchipText];
    
    starCount = [self generateTextFieldAt:CGRectMake(30,30,480,53)];
    starCount.font = [UIFont fontWithName:@"ZapfDingbatsITC" size:(24*windowFrame.size.height)/320];
    [starCount setTextColor:[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0]];
    [starCount setEnabled:FALSE];
    [starCount setText:[NSString stringWithFormat:@"✯x %d",[gameSave starsNumber]]];
    [self addSubview:starCount];
    
    passwordInput = [self generateTextFieldAt:CGRectMake(0,110,480,50)];
    passwordInput.font = [UIFont fontWithName:@"CourierNewPSMT" size:(85*baseBlockWidth)/480];
    passwordInput.delegate = self;
    passwordInput.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    passwordInput.textAlignment = NSTextAlignmentCenter;
    [passwordInput setText:@"00000000"];
    [self addSubview:passwordInput];
}
-(void)loadButtons{
    CGFloat scale = (0.05*windowFrame.size.height)/320;
    
    UIImage* tryButtonFrame = [UIImage imageNamed:@"tryButtonFrame"];
    tryButtonFrame = [UIUtilities imageWithImage:tryButtonFrame scaledRate:scale];
    tryButtonFrame = [UIUtilities insertCapInsetsIn:tryButtonFrame];
    
    tryCode = [self generateButtonAt:CGRectMake(30,215,200,70) withTitle:@"BUY"];
    tryCode.titleLabel.font = [UIFont systemFontOfSize:(60*baseBlockWidth)/480];
    [tryCode setBackgroundImage:tryButtonFrame forState:UIControlStateNormal];
    [tryCode addTarget:self action:@selector(tryCard:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tryCode];
    
    UIImage* backButtonFrame = [UIImage imageNamed:@"backButtonFrame"];
    backButtonFrame = [UIUtilities imageWithImage:backButtonFrame scaledRate:scale];
    backButtonFrame = [UIUtilities insertCapInsetsIn:backButtonFrame];
    
    backCode = [self generateButtonAt:CGRectMake(250,215,200,70) withTitle:@"BACK"];
    backCode.titleLabel.font = [UIFont systemFontOfSize:(60*baseBlockWidth)/480];
    [backCode setBackgroundImage:backButtonFrame forState:UIControlStateNormal];
    [backCode addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:backCode];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        windowFrame = CGRectMake(frame.origin.x, frame.origin.y+20, frame.size.width, frame.size.height-20);
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [self setBackgroundColor:[UIColor blackColor]];
    [self initCard];
    [self calculateBaseBlockWidth];
    [self loadBackground];
    [self loadTextFields];
    [self loadButtons];
    
    [audioPlayer setBGMusic:@"PassMenuTrack" ofExtension:@"mp3"];
}

-(void)tryCard:(UIButton*)sender{    
    value = [gameSave.gameCards getStarValueOfCardSerial:[passwordInput text]];
    if (value>0){
        [self loadCard:[NSCard getCardPicture:[passwordInput text]]];
        if (value <= [[[starCount text] substringFromIndex:3] intValue]){
            NSString* message = [NSString stringWithFormat:@"This card costs %d stars.\nDo you really want to buy it?",value];
            buyingAlert = [[UIAlertView alloc] initWithTitle:@"Buying Card" message:message delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            [buyingAlert show];
        }
        else [self showMessage:[NSString stringWithFormat:@"This card costs %d stars.\nYou don't have enough stars.",value]];
    }
    else{
        if (value==-1) [self showInvalidMessage:@"This card is unique.\nYou won't find it for sale."];
        else [self showInvalidMessage:[NSString stringWithFormat:@"The code %@ is invalid.",[passwordInput text]]];
    }
}
-(void)backToMenu:(UIButton*)sender{
    [UIUtilities playSound:@"returnAction" ofType:@"wav"];
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.superview.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         self.alpha = 0.0;
                         [audioPlayer setBGMusic:@"MainMenuTrack" ofExtension:@"aac"];
                         [(UIMainMenuView*)self.superview addTitleMenuButtons];
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.superview.alpha = 1.0;
                                              [self removeFromSuperview];
                                          }
                                          completion:nil];
                     }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView == buyingAlert){
        [UIUtilities playSound:@"selectAction" ofType:@"wav"];
        [gameSave setStarsNumber:[gameSave starsNumber]-value];
        [starCount setText:[NSString stringWithFormat:@"✯x %d",[gameSave starsNumber]]];
        [gameSave addCardToBox:[[gameSave.gameCards getCardWithSerial:[passwordInput text]] cardID]];
    }
    if (alertView != invalidAlert) [self loadCard:[UIImage imageNamed:@"FaceDown"]];
    value = 0;
}

-(BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if (range.length>1) return NO;
    if (range.location==8) return NO;
    if ([string rangeOfCharacterFromSet:set].location == NSNotFound) return NO;
    if ([string isEqualToString:@""]) return NO;
    
    if (range.length==0) {
        range.length++;
        UITextPosition *beginning = textField.beginningOfDocument;
        UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
        UITextPosition *end = [textField positionFromPosition:start offset:range.length];
        UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
        [textField setSelectedTextRange:textRange];
    }

    [UIUtilities playSound:@"selectAction" ofType:@"wav"];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField*)textField{
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *start = [textField positionFromPosition:beginning offset:0];
    UITextPosition *end = [textField positionFromPosition:start offset:0];
    UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
    [textField setSelectedTextRange:textRange];
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [passwordInput resignFirstResponder];
    return YES;
}

@end
