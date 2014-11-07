//
//  NSCard.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 23/02/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ContainsClass)

-(BOOL)contains:(NSString*)string;

@end

typedef enum BattleResult
{
    BattleWon,
    BattleLostWhileAttackPosition,
    BattleLostWhileDefensePosition,
    BattleDrawWhileAttackPosition,
    BattleDrawWhileDefensePosition
} BattleResult;

typedef enum GuardianStar
{
    Mercury,
    Sun,
    Moon,
    Venus,
    Mars,
    Jupiter,
    Saturn,
    Uranus,
    Pluto,
    Neptune
} GuardianStar;

typedef enum GuardianStarEffect
{
    YourBigger,
    EnemyBigger,
    Nothing
} GuardianStarEffect;

@interface NSCard : NSObject{
    NSArray* cards;
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *rarity;
@property(nonatomic, retain) NSString *circulation;
@property(nonatomic, retain) NSString *cardId;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *serial;
@property(nonatomic, retain) NSString *type;
@property(nonatomic) int cardID;

@property(nonatomic, retain) NSString *attribute;
@property(nonatomic, retain) NSString *level;
@property(nonatomic) GuardianStar guardianStarOne;
@property(nonatomic) GuardianStar guardianStarTwo;
@property(nonatomic) int attack;
@property(nonatomic) int defense;
@property(nonatomic) BOOL female;
@property(nonatomic) BOOL isAnimal;
@property(nonatomic) BOOL isDarkMagic;
@property(nonatomic) BOOL isDarkSpellcaster;
@property(nonatomic) BOOL isDragon;
@property(nonatomic) BOOL isElf;
@property(nonatomic) BOOL isFemale;
@property(nonatomic) BOOL isHFDMaterial;
@property(nonatomic) BOOL isJar;
@property(nonatomic) BOOL isKoumoriMaterial;
@property(nonatomic) BOOL isMysticalMaterial;
@property(nonatomic) BOOL isPyro;
@property(nonatomic) BOOL isTurtle;
@property(nonatomic) BOOL isWinged;

//Battle Only Attributes
@property(nonatomic) BOOL isInAttackPosition;
@property(nonatomic) GuardianStar activeGuardianStar;

-(NSCard*)getCardWithID:(int)idCard;
-(NSCard*)getCardWithSerial:(NSString*)serial;
-(void)setCard:(NSDictionary*)card;

+(int)getNumberOfCards;
-(UIImage*)image;
+(UIImage*)getCardPicture:(NSString*)code;

-(UIImage*)getTypeIcon;
+(UIImage*)getGuardianStarSymbol:(GuardianStar)guard;
+(NSString*)getGuardianStarName:(GuardianStar)guard;
+(GuardianStar)getGuardianStarForString:(NSString*)string;

-(int)getStarValueOfCardSerial:(NSString*)serial;

-(NSArray*)sortRandomMonsters:(int)number WithMoreThen:(int)min andLessThen:(int)max withExtra:(NSArray*)extra;
-(int)sortRandomMagic;

-(BOOL)isMonster;
-(BOOL)isSpell;

-(BOOL)isMagic;
-(BOOL)isEquip;
-(BOOL)isRitual;
-(BOOL)isField;

-(BOOL)isTrap;

@end
