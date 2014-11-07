//
//  UIFreeDuelView.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 05/05/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIMainMenuView.h"

@interface UIFreeDuelView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>{
    CGRect windowFrame;
    CGRect collectionFrame;
    int sideSpace;
    int cellSide;
    
    UICollectionView* duelistsGrid;
    UITextField* freeDuelText;
    NSArray* duelists;
}

@end
