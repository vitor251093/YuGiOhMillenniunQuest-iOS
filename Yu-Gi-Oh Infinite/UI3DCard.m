//
//  UI3DCard.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 10/04/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UI3DCard.h"

@implementation UI3DCard

-(instancetype)initWithFrame:(CGRect)frame andCard:(NSCard*)newCard{
    self = [super initWithFrame:frame];
    if (self){
        [self setCard:newCard];
    }
    return self;
}

-(void)insertInPositionWithAnimation:(int)position{
    
}

-(void)setYAxis:(CGFloat)y{
    
}

-(void)setCard:(NSCard*)newCard{
    card = newCard;
}

@end
