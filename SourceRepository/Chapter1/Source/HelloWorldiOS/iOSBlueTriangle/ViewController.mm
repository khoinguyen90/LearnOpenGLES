//
//  ViewController.m
//  iOSBlueTriangle
//
//  Created by macbook on 8/29/13.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import "ViewController.h"
#include "NativeTemplate.h"


@interface ViewController () {
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation ViewController

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [_context release];
    [super dealloc];
}

- (void) shouldAutorotate
{
    [EAGLContext setCurrentContext:self.context];
    
    GraphicsResize(self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3] autorelease];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];

    //Optional code to demonstrate how can you bind frame buffer and render buffer.
    GLint defaultFBO;
    GLint defaultRBO;

    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &defaultFBO);
    glGetIntegerv(GL_RENDERBUFFER_BINDING, &defaultRBO);
    
    glBindFramebuffer( GL_FRAMEBUFFER, defaultFBO );
    glBindRenderbuffer( GL_RENDERBUFFER, defaultRBO );
    
    GraphicsInit();

}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    GraphicsRender();
}


@end
