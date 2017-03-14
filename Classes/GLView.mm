#import "GLView.h"

#define GL_RENDERBUFFER 0x8d41

@interface GLView()
@property (nonatomic, strong) UISwitch *changeSwitch;
@end

@implementation GLView

+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

- (id) initWithFrame: (CGRect) frame
{
    if (self = [super initWithFrame:frame])
    {
        NSString *test = [[NSString alloc]initWithFormat:@"%@",@"test" ];
        CAEAGLLayer* eaglLayer = (CAEAGLLayer*) self.layer;
        eaglLayer.opaque = YES;

        EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
        m_context = [[EAGLContext alloc] initWithAPI:api];
        
        if (!m_context) {
            api = kEAGLRenderingAPIOpenGLES1;
            m_context = [[EAGLContext alloc] initWithAPI:api];
        }
        
        if (!m_context || ![EAGLContext setCurrentContext:m_context]) {
            [self release];
            return nil;
        }
        
        m_resourceManager = Darwin::CreateResourceManager();

        if (api == kEAGLRenderingAPIOpenGLES1) {
            NSLog(@"Using OpenGL ES 1.1");
            m_renderingEngine = TexturedES1::CreateRenderingEngine(m_resourceManager);
        } else {
            NSLog(@"Using OpenGL ES 2.0");
            m_renderingEngine = TexturedES2::CreateRenderingEngine(m_resourceManager);
        }

       m_applicationEngine = ParametricViewer::CreateApplicationEngine(m_renderingEngine);

        [m_context
            renderbufferStorage:GL_RENDERBUFFER
            fromDrawable: eaglLayer];
                
        int width = CGRectGetWidth(frame);
        int height = CGRectGetHeight(frame);
        m_applicationEngine->Initialize(width, height);
        
        [self drawView: nil];
        m_timestamp = CACurrentMediaTime();
        
        CADisplayLink* displayLink;
        displayLink = [CADisplayLink displayLinkWithTarget:self
                                     selector:@selector(drawView:)];
        
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                     forMode:NSDefaultRunLoopMode];
        
        self.changeSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(10, 30, 10, 10)];
        [self addSubview:self.changeSwitch];
        [self.changeSwitch addTarget:self action:@selector(change) forControlEvents:UIControlEventValueChanged];
        
    }
    return self;
}

- (void)change
{
    m_renderingEngine->m_isOn = self.changeSwitch.on;
}

- (void) drawView: (CADisplayLink*) displayLink
{
    if (displayLink != nil) {
        float elapsedSeconds = displayLink.timestamp - m_timestamp;
        m_timestamp = displayLink.timestamp;
        m_applicationEngine->UpdateAnimation(elapsedSeconds);
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

namespace FacetedES2 { IRenderingEngine* CreateRenderingEngine() { return 0; } }
namespace SolidGL2 { IRenderingEngine* CreateRenderingEngine() { return 0; } }
namespace TexturedGL2 { IRenderingEngine* CreateRenderingEngine() { return 0; } }

