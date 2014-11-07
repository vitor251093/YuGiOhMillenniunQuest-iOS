//
//  ViewUtilities.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 06/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UIUtilities.h"

NSGame* gameSave;
AudioPlayer* audioPlayer;

@implementation UIUtilities

+(NSString*)intToString:(int)integer WithHouses:(int)houses{
    NSString* result = [NSString stringWithFormat:@"%d",integer];
    while ([result length] < houses)
        result = [NSString stringWithFormat:@"0%@",result];
    return result;
}

+(NSMutableArray*)removeDuplicates:(NSArray*)array{
    NSMutableArray* newOne = [[NSMutableArray alloc] init];
    for (NSString* value in array)
        if (![newOne containsObject:value]) [newOne addObject:value];
    return newOne;
}

+(void)playSound:(NSString*)name ofType:(NSString*)ext{
    SystemSoundID menuItemClickSound;
    NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:name withExtension:ext];
    AudioServicesCreateSystemSoundID( (__bridge CFURLRef)soundFileURL, &menuItemClickSound);
    AudioServicesAddSystemSoundCompletion(menuItemClickSound, nil, nil, nil, (__bridge void*) self);
    AudioServicesPlaySystemSound( menuItemClickSound );
}

+(CGFloat)widthOfString:(NSString*)string withFont:(UIFont*)font{
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
	return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

+(UIImage*)imageWithImage:(UIImage*)image scaledRate:(CGFloat)resizeRate{
    CGSize newSize =CGSizeMake(image.size.width*resizeRate,image.size.height*resizeRate);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(UIImage*)insertCapInsetsIn:(UIImage*)image{
    UIEdgeInsets inactiveInsets = UIEdgeInsetsMake(image.size.height/2,image.size.width/2,
                                                   image.size.height/2,image.size.width/2);
    return [image resizableImageWithCapInsets:inactiveInsets];
}

+(CGRect)addBorder:(CGRect)rect atPercent:(CGFloat)perc{
    return CGRectMake(rect.size.width*perc/200 + rect.origin.x,rect.size.height*perc/200 + rect.origin.y,
                      (rect.size.width*(100-perc))/100,(rect.size.height*(100-perc))/100);
}

+(UIColor*)colorWithHex:(NSString*)hex{
    int x;
    char ds[6];
    
    for (x=0;x<6;x++){
        ds[x] = [hex characterAtIndex:x];
        if (ds[x] >= 'a') ds[x] = ds[x] - 'a' + 10;
        else if (ds[x] >= '0') ds[x] = ds[x] - '0';
    }
    
    int red = ds[0]*16 + ds[1];
    int gre = ds[2]*16 + ds[3];
    int blu = ds[4]*16 + ds[5];
    return [UIColor colorWithRed:red/255.0 green:gre/255.0 blue:blu/255.0 alpha:1.0];
}

@end
