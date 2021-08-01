//
//  VideoService.m
//  FaceWorkflow
//
//  Created by lieon on 2021/8/1.
//

#import "VideoService.h"
#include "VideoPlayer.hpp"

@interface VideoService()
{
    VideoPlayer *player;
}
@end

@implementation VideoService

- (instancetype)init
{
    self = [super init];
    if (self) {
        player = new VideoPlayer();
    }
    return self;
}

- (void)setFilename:(NSString *)filename {
    player->setFilename(filename.UTF8String);
}

- (void)play {
    player->play();
}
@end
