//
//  GLDuelFieldView.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 15/06/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface GLDuelFieldView : UIView{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
}

@end
