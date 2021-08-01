//
//  VideoPlayer.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/7/30.
//

#include "VideoPlayer.hpp"
#include <SDL.h>

VideoPlayer::VideoPlayer() {
    SDL_SetMainReady();
    if (SDL_Init(SDL_INIT_AUDIO)) {
        cout << "SDL_Init error" << SDL_GetError() << endl;
        return;
    }
}

VideoPlayer::~VideoPlayer() {
    SDL_Quit();
}

void VideoPlayer::setFilename(string name) {
    const char *filename = name.c_str();
    memcpy(this->filename, filename, strlen(filename) + 1);
}

int VideoPlayer::initDecoder(AVCodecContext **decodecCtx, AVStream**stream, AVMediaType type) {
    return 0;
}

void VideoPlayer::readFile() {
    int ret = 0;
    // 创建解封装上下文
    ret = avformat_open_input(&fmtCtx, filename, nullptr, nullptr);
    END(avformat_open_input);
    
    // 检索流信息
    ret = avformat_find_stream_info(fmtCtx, nullptr);
    END(avformat_find_stream_info);
    
    // 打印流信息到控制台
    av_dump_format(fmtCtx, 0, filename, 0);
    fflush(stderr);
    
    // 初始化音频信息
    hasAudio = initAudioInfo();
    // 初始化视频信息
    // 到此为止初始化完毕
    
    SDL_PauseAudio(0);
    AVPacket pkt;
    while (true) {
        ret = av_read_frame(fmtCtx, &pkt);
        if (ret == 0) {
            if (pkt.stream_index == aStream->index) {
                addAudioPkt(pkt);
            }
        } else if (ret == AVERROR_EOF) {
            
        } else {
            ERROR_BUF;
            continue;
        }
    }
}

void VideoPlayer::free() {
    
}

void VideoPlayer::fataError() {
    
}
