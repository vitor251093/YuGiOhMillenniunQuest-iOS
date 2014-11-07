//
//  GL3DObject.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 15/06/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "GL3DObject.h"

@implementation GL3DObject

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self){
        windowFrame = frame;
    }
    return self;
}
-(void)setPerspectiveCenter:(CG3DPoint)point{
    perspectiveCenter = point;
}
-(void)updateUI{
    NSLog(@"Create your own update");
}

-(CGPoint)rasterize3DRect:(CG3DPoint)point3D{
    CGPoint point;
    
    CGFloat senCO = perspectiveCenter.y - point3D.y;
    CGFloat senCA = perspectiveCenter.x - point3D.x;
    CGFloat senH = sqrtf(pow(senCA,2) + pow(senCO,2));
    CGFloat sen = senCO/senH;
    CGFloat cos = sqrtf(1 - pow(sen,2));
    
    CGFloat topSpace = sen*(point3D.z*senH)/perspectiveCenter.z;
    CGFloat leftSpace = cos*(point3D.z*senH)/perspectiveCenter.z;
    
    point.y = point3D.y + topSpace;
    point.x = point3D.x + (senCA > 0 ? leftSpace : - leftSpace);
    
    return point;
}

-(float*)getPlaneWithUpLeft:(CGPoint)upLeft upRight:(CGPoint)upRight downLeft:(CGPoint)downLeft downRight:(CGPoint)downRight{
    float* list = malloc(sizeof(float)*8);
    
    list[0] = upLeft.x;
    list[1] = upLeft.y;
    list[2] = upRight.x;
    list[3] = upRight.y;
    list[4] = downLeft.x;
    list[5] = downLeft.y;
    list[6] = downRight.x;
    list[7] = downRight.y;
    
    return list;
}

@end
