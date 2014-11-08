//
//  UIFreeDuelView.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 05/05/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UIFreeDuelView.h"

#define BASE_WINDOW_MARGIN 20

@implementation UIFreeDuelView

-(UITextField*)generateTextFieldAtFrame:(CGRect)frame withColor:(UIColor*)color{
    UITextField* textField = [[UITextField alloc] initWithFrame:frame];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.textColor = color;
    textField.backgroundColor = [UIColor clearColor];
    textField.enabled = NO;
    return textField;
}
-(UIButton*)generateButtonAt:(CGRect)position withTitle:(NSString*)title{
    UIButton* result = [[UIButton alloc] initWithFrame:position];
    [result setTitle:title forState:UIControlStateNormal];
    [result setTitle:title forState:UIControlStateHighlighted];
    [result setUserInteractionEnabled:TRUE];
    [result setEnabled:TRUE];
    return result;
}

-(void)generateMainText{
    freeDuelText = [self generateTextFieldAtFrame:[UIUtilities addBorder:CGRectMake(0,BASE_WINDOW_MARGIN,windowFrame.size.width,
                                                                                    collectionFrame.origin.y-BASE_WINDOW_MARGIN)
                                                               atPercent:20] withColor:[UIUtilities colorWithHex:@"95b3a5"]];
    freeDuelText.text = @"FREE DUEL";
    freeDuelText.font = [UIFont systemFontOfSize:collectionFrame.origin.y/1.8];
    [self addSubview:freeDuelText];
}
-(void)generateReturnButton{
    UIButton* returnButton = [self generateButtonAt:CGRectMake(collectionFrame.origin.x, BASE_WINDOW_MARGIN, collectionFrame.size.width/4,
                                                               collectionFrame.origin.y - BASE_WINDOW_MARGIN) withTitle:@"Back"];
    int widthText = [UIUtilities widthOfString:@"Back" withFont:[[returnButton titleLabel] font]];
    [returnButton setFrame:CGRectMake(returnButton.frame.origin.x,returnButton.frame.origin.y,
                                      widthText*1.1,returnButton.frame.size.height)];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [returnButton addTarget:self action:@selector(backToMenu:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:returnButton];
}
-(void)generateCollectionView{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    duelistsGrid = [[UICollectionView alloc] initWithFrame:collectionFrame collectionViewLayout:layout];
    duelistsGrid.delegate = self;
    duelistsGrid.dataSource = self;
    [duelistsGrid registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [duelistsGrid setBackgroundColor:[UIUtilities colorWithHex:@"313939"]];
    [self addSubview:duelistsGrid];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        windowFrame = frame;
        [self setBackgroundColor:[UIUtilities colorWithHex:@"424a4a"]];
        
        collectionFrame = CGRectMake(windowFrame.origin.x+BASE_WINDOW_MARGIN,     windowFrame.origin.y+(windowFrame.size.height*14)/100,
                                     windowFrame.size.width-2*BASE_WINDOW_MARGIN, (windowFrame.size.height*86)/100 - BASE_WINDOW_MARGIN);
        cellSide = collectionFrame.size.width/5.5;
        
        duelists = [[NSArray alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Duelists" withExtension:@"plist"]];
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    [self generateCollectionView];
    [self generateMainText];
    [self generateReturnButton];
    
    [duelistsGrid reloadData];
    [audioPlayer setBGMusic:@"FreeDuelTrack" ofExtension:@"mp3"];
}
-(void)fadeToDuelWith:(int)duelistNumber{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.superview.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         UIView* nextView;
                         if (duelistNumber)
                              nextView = [[UIDuelView alloc] initWithFrame:windowFrame withDuelist:duelistNumber-1 atFreeDuel:YES];
                         else nextView = [[UIBuildDeckView alloc] initWithFrame:windowFrame atDuel:NO inFreeDuel:YES];
                         [audioPlayer stop];
                         [self addSubview:nextView];
                         
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.superview.alpha = 1.0;
                                          }
                                          completion:nil];
                     }];
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) return [duelists count]+1;
    return 0;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    if ([indexPath section]==0){
        for (UIView* sub in [cell subviews]) [sub removeFromSuperview];
        int num = (int)[indexPath item];
        
        NSDictionary* duelist;
        UIImage* iconImage;
        NSString* tempName;
        
        if (num!=0){
            duelist = [duelists objectAtIndex:num-1];
            iconImage = [UIImage imageNamed:[duelist objectForKey:@"Picture"]];
            tempName = [duelist objectForKey:@"Name"];
        }else{
            iconImage = [UIImage imageNamed:@"duelistBuildDeck"];
            tempName = @"Build Deck";
        }
        
        if (iconImage){
            UIImageView* icon = [[UIImageView alloc] initWithImage:iconImage];
            [icon setFrame:CGRectMake(0,0,cellSide,cellSide)];
            [cell addSubview:icon];
        }
        else{
            [cell setBackgroundColor:[UIColor whiteColor]];
            UITextField* tempText = [self generateTextFieldAtFrame:CGRectMake(0,0,cellSide,cellSide) withColor:[UIColor blackColor]];
            [tempText setText:tempName];
            [cell addSubview:tempText];
        }
    }
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self fadeToDuelWith:(int)[indexPath item]];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(cellSide, cellSide);
}

@end
