//
//  UI3DCard.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 10/04/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UI3DObject.h"
#import "NSCard.h"

@interface UI3DCard : UI3DObject{
    NSCard* card;
}

-(instancetype)initWithFrame:(CGRect)frame andCard:(NSCard*)newCard;

-(void)setCard:(NSCard*)newCard;
-(void)insertInPositionWithAnimation:(int)position;

@end
