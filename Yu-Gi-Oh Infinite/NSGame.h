//
//  NSGame.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 07/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSCard.h"

@interface NSGame : NSObject <UIAlertViewDelegate>{
    NSMutableDictionary* player;
    
    UIAlertView *overwriteAlert;
    UIAlertView *saveAlert;
    UIAlertView *characterNameAlert;
}

@property (nonatomic,strong) NSCard* gameCards;

+(NSString*)savePath;

-(void)newGameWithName:(NSString*)name;

-(instancetype)initNewGame;
-(instancetype)initWithSavedState;

-(void)createGameSaveDialog;
-(void)saveGame;

-(void)addCardToBox:(int)idCard;
-(void)removeCardFromBox:(int)idCard;
-(NSArray*)box;
-(int)countCardAtBox:(int)idCard;
-(void)setBox:(NSArray*)box;

-(void)addCardToDeck:(int)idCard;
-(void)removeCardFromDeck:(int)idCard;
-(NSArray*)deck;
-(int)countCardAtDeck:(int)idCard;
-(void)setDeck:(NSArray*)deck;

-(void)campaign;

-(int)starsNumber;
-(void)setStarsNumber:(int)stars;
-(void)addStarsNumber:(int)stars;

-(id)objectForKey:(NSString*)key;
-(void)writeToFile:(NSString*)file atomically:(BOOL)atom;

@end
