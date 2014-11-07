//
//  UI3DField.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 10/04/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import "UI3DObject.h"

@interface UI3DField : UI3DObject{
    CG3DRect field;
    UIView* view;
    
    CAShapeLayer* faceBack;
    CAShapeLayer* faceLeft;
    CAShapeLayer* faceRight;
    CAShapeLayer* faceTop;
    CAShapeLayer* faceFront;
    
    CGRect fieldFrame;
    CGFloat fieldDeep;
    int perspectiveZ;
}

-(void)setView:(UIView*)newView;
-(void)removeField;
-(void)setFieldWithFrame:(CGRect)frame andDeepness:(CGFloat)deep atPerspective:(CGFloat)pers withRotation:(CGFloat)rotationAngle;
-(void)setPerspective:(CGFloat)pers;
-(void)reducePerspective:(NSTimer*)timer;

@end
