//
//  UI3DObject.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 27/03/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UI3DObject.h"

CG3DPoint CG3DPointMake(CGFloat x, CGFloat y, CGFloat z){
    CG3DPoint rect;
    rect.x = x;
    rect.y = y;
    rect.z = z;
    return rect;
}
CG3DRect CG3DStructMake(CG3DPoint uln, CG3DPoint urn, CG3DPoint dln, CG3DPoint drn, CG3DPoint uld, CG3DPoint urd, CG3DPoint dld, CG3DPoint drd){
    CG3DRect struc;
    struc.pointUpLeftNear = uln;
    struc.pointUpRightNear = urn;
    struc.pointDownLeftNear = dln;
    struc.pointDownRightNear = drn;
    
    struc.pointUpLeftDist = uld;
    struc.pointUpRightDist = urd;
    struc.pointDownLeftDist = dld;
    struc.pointDownRightDist = drd;
    return struc;
}
CG3DPoint Rotate3DStruct(CG3DPoint struc, CGFloat angle, CG3DPoint center){
    int i,j;
    float rotationMatrix[3][3] = {{cos(angle),0,sin(angle)},{0,1,0},{-sin(angle),0,cos(angle)}};
    float vector[3] = {struc.x - center.x, struc.y - center.y, struc.z - center.z};
    float result[3] = {0,0,0};
    
    for (i=0;i<3;i++)
        for (j=0;j<3;j++)
            result[i] += rotationMatrix[i][j]*vector[j];
    
    struc.x = result[0] + center.x;
    struc.y = result[1] + center.y;
    struc.z = result[2] + center.z;
    return struc;
}

@implementation UI3DObject

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

-(void)drawGuideLinesAtView:(UIView*)view{
    CGPoint bPoint = CGPointMake(perspectiveCenter.x,perspectiveCenter.y);
    [[view layer] addSublayer:[self getPlaneWithUpLeft:CGPointMake(0,0) upRight:CGPointMake(windowFrame.size.width, 0)
                                              downLeft:bPoint downRight:bPoint]];
    [[view layer] addSublayer:[self getPlaneWithUpLeft:CGPointMake(0,windowFrame.size.height)
                                               upRight:CGPointMake(windowFrame.size.width, windowFrame.size.height)
                                              downLeft:bPoint downRight:bPoint]];
}
-(CAShapeLayer*)getPlaneWithUpLeft:(CGPoint)upLeft upRight:(CGPoint)upRight downLeft:(CGPoint)downLeft downRight:(CGPoint)downRight{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(upLeft.x, upLeft.y)];
    [path addLineToPoint:CGPointMake(upRight.x, upRight.y)];
    [path addLineToPoint:CGPointMake(downRight.x, downRight.y)];
    [path addLineToPoint:CGPointMake(downLeft.x, downLeft.y)];
    [path closePath];
    
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [[UIColor whiteColor] CGColor];
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 1.0;
    
    return shapeLayer;
}

@end
