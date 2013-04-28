//
//  GLView.h
//  Exercise2-HelloCone
//
//  Created by su_zhaoyang on 12-9-26.
//  Copyright (c) 2012年 su_zhaoyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include "Interfaces.hpp"


@interface GLView : UIView
{
@private
    IApplicationEngine* m_applicationEngine;
    EAGLContext* m_context;
    IRenderingEngine* m_renderingEngine;
    float m_timestamp;
}

-(void)drawView:(CADisplayLink*)displayLink;
-(void)didRotate:(NSNotification*)notification;

@end
