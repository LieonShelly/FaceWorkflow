//
//  RenderImageBridge.m
//  FaceWorkflow
//
//  Created by lieon on 2021/6/15.
//

#import "RenderImageBridge.h"
#include "RenderImage.hpp"
#include <MetalKit/MTKView.h>
@interface RenderImageBridge()
{
    RenderImage *renderImg;
}
@property (nonatomic, strong) MTKView *canvas;


@end

@implementation RenderImageBridge

- (MTKView *)canvas {
    if (!_canvas) {
        _canvas = [[MTKView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        _canvas.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _canvas;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.canvas];
    renderImg =  new RenderImage();
    BgfxInitInfo info;
    CGFloat scale = UIScreen.mainScreen.scale;
    info.width = int(UIScreen.mainScreen.bounds.size.width * scale);
    info.height = int(UIScreen.mainScreen.bounds.size.height * scale);
    info.nativeWindowHandle = (__bridge void*)self.canvas.layer;
    renderImg->initPlatform(info);
 
}

- (void)viewDidAppear:(BOOL)animated {
    Param *param = new Param();
    NSString *vsName = @"vs_cubes";
    NSString *fsName = @"fs_cubes";
    NSString *displayFsName = @"display_fs_cubes.sc";
    param->vsName = [vsName UTF8String];
    param->vsFullPath = [[self getShaderPathWithName:vsName] UTF8String];
    param->fsName = [fsName UTF8String];
    param->fsFullPath = [[self getShaderPathWithName:fsName] UTF8String];
    param->texturePath = [[[NSBundle mainBundle]pathForResource:@"TEST.png" ofType:nil] UTF8String];
    param->displayFsname = [displayFsName UTF8String];
    param->displayFsFullPth = [[self getShaderPathWithName:displayFsName] UTF8String];
    renderImg->setParam(param);
    
    renderImg->helloworld();
}

- (NSString*)getShaderPathWithName:(NSString*)name {
    NSString *newName = [name stringByAppendingPathExtension:@"bin"];
    NSString * shaderRootPath = [[NSBundle mainBundle] pathForResource:@"Shaders.bundle" ofType:nil];
    NSBundle * shaderBundle  = [NSBundle bundleWithPath:shaderRootPath];
    NSString * shaderMetalPath = [[shaderBundle resourcePath]stringByAppendingPathComponent:@"metal"];
    return [shaderMetalPath stringByAppendingPathComponent:newName];
}

@end
