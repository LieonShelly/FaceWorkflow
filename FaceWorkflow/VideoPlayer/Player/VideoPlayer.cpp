//
//  VideoPlayer.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/7/30.
//

#include "VideoPlayer.hpp"
#include <SDL.h>
#include <thread>

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
    // 根据type寻找到最合适的流信息
    int ret = av_find_best_stream(fmtCtx, type, -1, -1, nullptr, 0);
    RET(av_find_best_stream);
    // 获取流
    int streamIdx = ret;
    *stream = fmtCtx->streams[streamIdx];
    if (!*stream) {
        cout << "stream is empty" << endl;
        return -1;
    }
    // 为当前流找到合适的解码器
    AVCodec *decoder = avcodec_find_decoder((*stream)->codecpar->codec_id);
    if (!decoder) {
        cout << "avcodec_find_decoder is empty" << endl;
        return -1;
    }
    // 初始化解码器上下文
    *decodecCtx = avcodec_alloc_context3(decoder);
    if (!decodecCtx) {
        cout << "avcodec_alloc_context3 error" << endl;
    }
    // 从流中拷贝参数到解码器上下文中
    ret = avcodec_parameters_to_context(*decodecCtx, (*stream)->codecpar);
    RET(avcodec_parameters_to_context);
    // 打开解码器
    ret = avcodec_open2(*decodecCtx, decoder, nullptr);
    RET(avcodec_open2);
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
    hasVideo = initVideoInfo();
    // 到此为止初始化完毕
    cout << "初始化完毕" << endl;
    // 音频解码子线程：开始工作
    SDL_PauseAudio(0);
    // 视频解码子线程：开始工作
    thread([this]() {
        decodeVideo();
    }).detach();
    
    AVPacket pkt;
    while (true) {
        ret = av_read_frame(fmtCtx, &pkt);
        if (ret == 0) {
            if (pkt.stream_index == aStream->index) {
                addAudioPkt(pkt);
            } else if (pkt.stream_index == vStream->index) {
                addVideoPkt(pkt);
            } else {
                av_packet_unref(&pkt);
            }
        } else if (ret == AVERROR_EOF) {
            break;
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


void VideoPlayer::play() {
    thread([this]() {
        readFile();
    }).detach();
}


void VideoPlayer::setUserData(void * userData) {
    this->userData = userData;
}
