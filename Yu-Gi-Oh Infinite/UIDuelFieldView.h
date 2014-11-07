//
//  UIDuelFieldView.h
//  Yu-Gi-Oh Infinite
//
//  Created by Vitor Marques de Miranda on 11/04/14.
//  Copyright (c) 2014 Vitor Marques de Miranda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import "UI3DField.h"

@interface UIDuelFieldView : UIView{
    CGRect windowFrame;
    UI3DField* field;
}

@end
