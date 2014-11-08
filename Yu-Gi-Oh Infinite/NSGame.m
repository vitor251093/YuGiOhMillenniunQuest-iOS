//
//  NSGame.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 07/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "NSGame.h"

@implementation NSGame

+(NSString*)savePath{
    NSArray* documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentDir = [documentPaths objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:@"save.plist"];
}

-(void)newGameWithName:(NSString*)name{
    player = [[NSMutableDictionary alloc] init];
    [player setValue:name forKey:@"Name"];
    
    NSMutableArray* deck = [[NSMutableArray alloc] init];
    [deck addObjectsFromArray:[_gameCards sortRandomMonsters:35 WithMoreThen:0 andLessThen:2000 withExtra:@[]]];
    [deck addObjectsFromArray:[_gameCards sortRandomMonsters:3 WithMoreThen:0 andLessThen:2400 withExtra:@[]]];
    [deck addObject:@([_gameCards sortRandomMagic])];
    [deck addObject:@([_gameCards sortRandomMagic])];
    [player setValue:deck forKey:@"Deck"];
    
    NSMutableArray* box = [[NSMutableArray alloc] init];
    [player setValue:box forKey:@"Box"];
    
    [player setValue:0 forKey:@"State"];
    [player setValue:@(0) forKey:@"Stars"];
}

-(instancetype)initNewGame{
    self = [super init];
    if (self){
        _gameCards = [[NSCard alloc] init];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSGame savePath]]){
            NSString* message = @"Do you already have a saved state.\nDo you want to overwrite it?";
            overwriteAlert = [[UIAlertView alloc] initWithTitle:@"Overwrite Save" message:message delegate:self
                                              cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            [overwriteAlert show];
        } else [self createGameSaveDialog];
    }
    return self;
}
-(instancetype)initWithSavedState{
    self = [super init];
    if (self){
        _gameCards = [[NSCard alloc] init];
        player = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSGame savePath]];
    }
    return self;
}

-(void)createGameSaveDialog{
    characterNameAlert = [[UIAlertView alloc] initWithTitle:@"Character Name"
                                                    message:@"Input your character name"
                                                   delegate:self
                                          cancelButtonTitle:@"Accept"
                                          otherButtonTitles:@"Cancel", nil];
    characterNameAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [characterNameAlert show];
}
-(void)saveGame{
    saveAlert = [[UIAlertView alloc] initWithTitle:@"Saving"
                                           message:@"Do you want to save your progress?"
                                          delegate:self
                                 cancelButtonTitle:@"YES"
                                 otherButtonTitles:@"NO", nil];
    [saveAlert show];
}

-(void)addCardToBox:(int)idCard{
    [[player objectForKey:@"Box"] addObject:@(idCard)];
}
-(void)removeCardFromBox:(int)idCard{
    NSArray* tBox = [player objectForKey:@"Box"];
    for (int x=0;x<[tBox count];x++)
        if ([tBox[x] isEqual:@(idCard)]){
            [[player objectForKey:@"Box"] removeObjectAtIndex:x];
            return;
        }
}
-(NSArray*)box{
    return [player objectForKey:@"Box"];
}
-(int)countCardAtBox:(int)idCard{
    int count = 0;
    for (NSNumber *idCard2 in [self box]){
        if ([@(idCard) isEqual:idCard2]) count++;
    }
    return count;
}
-(void)setBox:(NSArray*)box{
    [player setObject:box forKey:@"Box"];
}

-(void)addCardToDeck:(int)idCard{
    [[player objectForKey:@"Deck"] addObject:@(idCard)];
}
-(void)removeCardFromDeck:(int)idCard{
    NSArray* tBox = [player objectForKey:@"Deck"];
    for (int x=0;x<[tBox count];x++)
        if ([tBox[x] isEqual:@(idCard)]){
            [[player objectForKey:@"Deck"] removeObjectAtIndex:x];
            return;
        }
}
-(NSArray*)deck{
    return [player objectForKey:@"Deck"];
}
-(int)countCardAtDeck:(int)idCard{
    int count = 0;
    for (NSNumber *idCard2 in [self deck]){
        if ([@(idCard) isEqual:idCard2]) count++;
    }
    return count;
}
-(void)setDeck:(NSArray*)deck{
    [player setObject:deck forKey:@"Deck"];
}

-(void)campaign{
    NSString* message = @"Here, you will be able to play the game story mode.";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Campaign Mode" message:message delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(int)starsNumber{
    return [[player objectForKey:@"Stars"] intValue];
}
-(void)setStarsNumber:(int)stars{
    [player setValue:@(stars) forKey:@"Stars"];
}
-(void)addStarsNumber:(int)stars{
    [player setValue:@([[player objectForKey:@"Stars"] intValue] + stars) forKey:@"Stars"];
}

-(id)objectForKey:(NSString*)key{
    return [player objectForKey:key];
}
-(void)writeToFile:(NSString*)file atomically:(BOOL)atom{
    [player writeToFile:file atomically:atom];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == overwriteAlert && buttonIndex == 0){
        [self createGameSaveDialog];
    }
    if (alertView == characterNameAlert && buttonIndex == 0){
        [self newGameWithName:[alertView textFieldAtIndex:0].text];
        [self writeToFile:[NSGame savePath] atomically:YES];
        [self campaign];
    }
    if (alertView == saveAlert && buttonIndex == 0){
        [self writeToFile:[NSGame savePath] atomically:YES];
        NSString* message = @"Your game state was saved successfully.";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Game Saved" message:message delegate:self
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
