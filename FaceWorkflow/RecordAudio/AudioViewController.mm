//
//  AudioViewController.m
//  FaceWorkflow
//
//  Created by lieon on 2021/6/18.
//

#import "AudioViewController.h"

#include "Test.hpp"

extern "C" {
// 设备
#include <libavdevice/avdevice.h>
// 格式
#include <libavformat/avformat.h>
// 工具
#include <libavutil/avutil.h>
}

@interface AudioViewController ()

@end

@implementation AudioViewController

- (void)loadView {
    [super loadView];
//    avdevice_register_all();
    Test *test = new Test();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
@end
