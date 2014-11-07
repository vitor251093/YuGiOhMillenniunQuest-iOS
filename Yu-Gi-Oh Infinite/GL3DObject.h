//
//  GL3DObject.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 15/06/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UI3DObject.h"

@interface GL3DObject : UI3DObject{
}

-(instancetype)initWithFrame:(CGRect)frame;
-(void)setPerspectiveCenter:(CG3DPoint)point;
-(void)updateUI;

-(CGPoint)rasterize3DRect:(CG3DPoint)point3D;

-(float*)getPlaneWithUpLeft:(CGPoint)upLeft upRight:(CGPoint)upRight downLeft:(CGPoint)downLeft downRight:(CGPoint)downRight;


@end
