//
//  Test.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/6/18.
//

#ifndef Test_hpp
#define Test_hpp

#include <stdio.h>

extern "C" {
// 设备
#include "libavdevice/avdevice.h"
// 格式
#include <libavformat/avformat.h>
// 工具
#include <libavutil/avutil.h>
}
class Test {
    
    
public:
    Test() {
        avdevice_register_all();
    }
};
#endif /* Test_hpp */
