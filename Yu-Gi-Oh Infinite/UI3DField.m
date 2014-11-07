//
//  UI3DField.m
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 10/04/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UI3DField.h"

@implementation UI3DField

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        CGFloat height = 4*windowFrame.size.height/15;
        CGFloat width = (height*23)/5;
        CGFloat y = windowFrame.size.height - height;
        CGFloat x = (windowFrame.size.width - width)/2;
        fieldFrame = CGRectMake(x, y, width, height);
        fieldDeep = 160*(56*windowFrame.size.height/23)/windowFrame.size.width;
        perspectiveZ = 580;
    }
    return self;
}
-(void)setView:(UIView*)newView{
    view = newView;
}

-(void)updateUI{
    CGPoint uln_ = [self rasterize3DRect:field.pointUpLeftNear];
    CGPoint urn_ = [self rasterize3DRect:field.pointUpRightNear];
    CGPoint dln_ = [self rasterize3DRect:field.pointDownLeftNear];
    CGPoint drn_ = [self rasterize3DRect:field.pointDownRightNear];
    
    CGPoint uld_ = [self rasterize3DRect:field.pointUpLeftDist];
    CGPoint urd_ = [self rasterize3DRect:field.pointUpRightDist];
    CGPoint dld_ = [self rasterize3DRect:field.pointDownLeftDist];
    CGPoint drd_ = [self rasterize3DRect:field.pointDownRightDist];
    
    faceBack  = [self getPlaneWithUpLeft:uld_ upRight:urd_ downLeft:dld_ downRight:drd_];
    faceLeft  = [self getPlaneWithUpLeft:uln_ upRight:uld_ downLeft:dln_ downRight:dld_];
    faceRight = [self getPlaneWithUpLeft:urn_ upRight:urd_ downLeft:drn_ downRight:drd_];
    faceTop   = [self getPlaneWithUpLeft:uld_ upRight:urd_ downLeft:uln_ downRight:urn_];
    faceFront = [self getPlaneWithUpLeft:uln_ upRight:urn_ downLeft:dln_ downRight:drn_];
    
    [self drawField];
}
-(void)drawField{
    [[view layer] addSublayer:faceBack ];
    [[view layer] addSublayer:faceLeft ];
    [[view layer] addSublayer:faceRight];
    [[view layer] addSublayer:faceTop  ];
    [[view layer] addSublayer:faceFront];
}
-(void)removeField{
    [faceBack  removeFromSuperlayer];
    [faceBack  removeFromSuperlayer];
    [faceLeft  removeFromSuperlayer];
    [faceRight removeFromSuperlayer];
    [faceTop   removeFromSuperlayer];
    [faceFront removeFromSuperlayer];
}

-(void)setFieldWithFrame:(CGRect)frame andDeepness:(CGFloat)deep atPerspective:(CGFloat)pers withRotation:(CGFloat)rotationAngle{
    CGFloat bodyDeep = frame.size.width;
    
    CG3DPoint uln = CG3DPointMake(frame.origin.x,                          frame.origin.y,                     pers);
    CG3DPoint urn = CG3DPointMake(frame.origin.x + frame.size.width,       frame.origin.y,                     pers);
    CG3DPoint dln = CG3DPointMake(frame.origin.x - frame.size.width/10,    frame.origin.y + frame.size.height, pers);
    CG3DPoint drn = CG3DPointMake(frame.origin.x + 11*frame.size.width/10, frame.origin.y + frame.size.height, pers);
    
    CG3DPoint uld = CG3DPointMake(frame.origin.x,                          frame.origin.y,                     pers + bodyDeep);
    CG3DPoint urd = CG3DPointMake(frame.origin.x + frame.size.width,       frame.origin.y,                     pers + bodyDeep);
    CG3DPoint dld = CG3DPointMake(frame.origin.x - frame.size.width/10,    frame.origin.y + frame.size.height, pers + bodyDeep);
    CG3DPoint drd = CG3DPointMake(frame.origin.x + 11*frame.size.width/10, frame.origin.y + frame.size.height, pers + bodyDeep);
    
    CG3DPoint fieldCenter = CG3DPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2, pers + bodyDeep/2);
    
    uln = Rotate3DStruct(uln, rotationAngle, fieldCenter);
    urn = Rotate3DStruct(urn, rotationAngle, fieldCenter);
    dln = Rotate3DStruct(dln, rotationAngle, fieldCenter);
    drn = Rotate3DStruct(drn, rotationAngle, fieldCenter);
    
    uld = Rotate3DStruct(uld, rotationAngle, fieldCenter);
    urd = Rotate3DStruct(urd, rotationAngle, fieldCenter);
    dld = Rotate3DStruct(dld, rotationAngle, fieldCenter);
    drd = Rotate3DStruct(drd, rotationAngle, fieldCenter);
    
    field = CG3DStructMake(uln, urn, dln, drn, uld, urd, dld, drd);
}
-(void)setPerspective:(CGFloat)pers{
    CGFloat rotationAngle = ((pers-70)/170)/2;
    [self setFieldWithFrame:fieldFrame andDeepness:fieldDeep atPerspective:pers withRotation:rotationAngle];
}
-(void)reducePerspective:(NSTimer*)timer{
    perspectiveZ--;
    [self setPerspective:perspectiveZ];
    [self removeField];
    [self updateUI];
    if (perspectiveZ==70) [timer invalidate];
}

@end
