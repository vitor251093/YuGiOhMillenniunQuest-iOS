//
//  UIDuelGroundView.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 27/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UI3DField.h"
#import "UIUtilities.h"
#import "UIDuelFieldView.h"
#import "GLDuelFieldView.h"
#import "UIBuildDeckView.h"

@interface UIDuelView : UIView{
    CGRect windowFrame;
    NSDictionary* opponent;
    BOOL isFreeDuel;
    
    UIDuelFieldView* fieldView;
    GLDuelFieldView* glFieldView;
}

-(id)initWithFrame:(CGRect)frame withDuelist:(int)duelist atFreeDuel:(BOOL)freeDuel;
-(void)startDuel;

@end
