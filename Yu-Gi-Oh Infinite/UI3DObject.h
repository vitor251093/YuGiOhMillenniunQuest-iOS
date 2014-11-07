//
//  UI3DObject.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 27/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct CG3DPoint{
    CGFloat x;
    CGFloat y;
    CGFloat z;
} CG3DPoint;

typedef struct CG3DRect{
    CG3DPoint pointUpLeftNear;
    CG3DPoint pointUpRightNear;
    CG3DPoint pointDownLeftNear;
    CG3DPoint pointDownRightNear;
    
    CG3DPoint pointUpLeftDist;
    CG3DPoint pointUpRightDist;
    CG3DPoint pointDownLeftDist;
    CG3DPoint pointDownRightDist;
} CG3DRect;

CG3DPoint CG3DPointMake(CGFloat x, CGFloat y, CGFloat z);
CG3DRect  CG3DStructMake(CG3DPoint uln, CG3DPoint urn, CG3DPoint dln, CG3DPoint drn, CG3DPoint uld, CG3DPoint urd, CG3DPoint dld, CG3DPoint drd);
CG3DPoint Rotate3DStruct(CG3DPoint struc, CGFloat angle, CG3DPoint ref);

@interface UI3DObject : NSObject{
    CGRect windowFrame;
    CG3DPoint perspectiveCenter;
}

-(instancetype)initWithFrame:(CGRect)frame;
-(void)setPerspectiveCenter:(CG3DPoint)point;
-(void)updateUI;

-(CGPoint)rasterize3DRect:(CG3DPoint)point3D;

-(void)drawGuideLinesAtView:(UIView*)view;
-(CAShapeLayer*)getPlaneWithUpLeft:(CGPoint)upLeft upRight:(CGPoint)upRight downLeft:(CGPoint)downLeft downRight:(CGPoint)downRight;

@end
