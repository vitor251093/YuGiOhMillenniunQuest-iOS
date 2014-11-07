//
//  UIBuildDeckView.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 11/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMainMenuView.h"
#import "UICardDetailsView.h"

@interface UIBuildDeckView : UIView <UITableViewDelegate, UITableViewDataSource>{
    UIImageView* orderTab;
    UIImage *buildDeckFrame;
    BOOL isDuel;
    BOOL isFreeDuel;
    
    int selectorPosition;
    UIImageView* selection;
    UIButton* returnButton;
    UIButton* chestButton;
    UIButton* moveCardButton;
    UIButton* deckButton;
    BOOL isSeenDeck;
    
    CGRect windowFrame;
    CGRect tableFrame;
    int sideSpace;
    
    UIColor* selColor;
    
    UITableView* boxTable;
    NSMutableArray* box;
    UITableView* deckTable;
    NSMutableArray* deck;
}

-(id)initWithFrame:(CGRect)frame atDuel:(BOOL)duel inFreeDuel:(BOOL)freeDuel;

@end
