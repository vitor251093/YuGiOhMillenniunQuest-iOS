//
//  ViewUtilities.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 06/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "NSGame.h"
#import "AudioPlayer.h"

extern AudioPlayer* audioPlayer;
extern NSGame* gameSave;

@interface UIUtilities : NSObject

+(NSString*)intToString:(int)integer WithHouses:(int)houses;

+(NSMutableArray*)removeDuplicates:(NSArray*)array;

+(void)playSound:(NSString*)name ofType:(NSString*)ext;

+(CGFloat)widthOfString:(NSString*)string withFont:(UIFont*)font;

+(UIImage*)imageWithImage:(UIImage*)image scaledRate:(CGFloat)resizeRate;
+(UIImage*)insertCapInsetsIn:(UIImage*)image;

+(CGRect)addBorder:(CGRect)rect atPercent:(CGFloat)perc;

+(UIColor*)colorWithHex:(NSString*)hex;

@end
