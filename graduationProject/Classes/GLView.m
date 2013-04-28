//
//  GLView.m
//  Exercise2-HelloCone
//
//  Created by su_zhaoyang on 12-9-26.
//  Copyright (c) 2012年 su_zhaoyang. All rights reserved.
//

#import "GLView.h"
#import "Interfaces.hpp"

@implementation GLView

+(Class)layerClass
{
    return [CAEAGLLayer class];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CAEAGLLayer* eaglLayer = (CAEAGLLayer*)super.layer;
        eaglLayer.opaque = YES;
        EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
        m_context = [[EAGLContext alloc]initWithAPI:api];
   
        if(!m_context || ![EAGLContext setCurrentContext:m_context])
        {
            [self release];
            return nil;
        }
        
        m_renderingEngine =  CreateRenderingEngine();
        m_applicationEngine = CreateApplicationEngine(m_renderingEngine);
        [m_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
        m_applicationEngine->Initialize(CGRectGetWidth(frame), CGRectGetHeight(frame));
        [self drawView:nil];
        m_timestamp = CACurrentMediaTime();
        CADisplayLink* displayLink;
        displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//        [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
//        [[NSNotificationCenter defaultCenter]addObserver:self
//                                                selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        
    }
    return self;
}


-(void)drawView:(CADisplayLink *)displayLink
{
    if (displayLink)
    {
        float elapsedSecond = displayLink.timestamp - m_timestamp;
        m_timestamp = displayLink.timestamp;
        m_applicationEngine->UpdateAnimation(elapsedSecond);
    }
    m_applicationEngine->Render();
    [m_context presentRenderbuffer:GL_RENDERBUFFER];
}



- (void) touchesBegan: (NSSet*) touches withEvent: (UIEvent*) event
{
    UITouch* touch = [touches anyObject];
    CGPoint location  = [touch locationInView: self];
    m_applicationEngine->OnFingerDown(ivec2(location.x, location.y));
}

- (void) touchesEnded: (NSSet*) touches withEvent: (UIEvent*) event
{
    UITouch* touch = [touches anyObject];
    CGPoint location  = [touch locationInView: self];
    m_applicationEngine->OnFingerUp(ivec2(location.x, location.y));
}

- (void) touchesMoved: (NSSet*) touches withEvent: (UIEvent*) event
{
    UITouch* touch = [touches anyObject];
    CGPoint previous  = [touch previousLocationInView: self];
    CGPoint current = [touch locationInView: self];
    m_applicationEngine->OnFingerMove(ivec2(previous.x, previous.y),
                                      ivec2(current.x, current.y));
}





@end
