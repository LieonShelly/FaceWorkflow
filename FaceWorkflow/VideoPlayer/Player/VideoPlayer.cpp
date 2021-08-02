//
//  VideoPlayer.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/7/30.
//

#include "VideoPlayer.hpp"
#include <SDL.h>
#include <thread>

#define AUDIO_MAX_PKT_SIZE 1000
#define VIDEO_MAX_PKT_SIZE 500

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
    hasAudio = initAudioInfo() >= 0;
    // 初始化视频信息
    hasVideo = initVideoInfo() >= 0;
    // 到此为止初始化完毕
    cout << "初始化完毕" << endl;
    setState(Playing);
    // 音频解码子线程：开始工作
    SDL_PauseAudio(0);
    // 视频解码子线程：开始工作
    thread([this]() {
        decodeVideo();
    }).detach();
    
    AVPacket pkt;
    while (true) {
        // 处理Seek操作
        int vSize = (int)vPktList.size();
        int aSize = (int)aPktList.size();
        if (vSize >= AUDIO_MAX_PKT_SIZE || aSize >= AUDIO_MAX_PKT_SIZE) {
            continue;
        }
        ret = av_read_frame(fmtCtx, &pkt);
        if (ret == 0) {
            if (pkt.stream_index == aStream->index) {
                addAudioPkt(pkt);
            } else if (pkt.stream_index == vStream->index) {
                addVideoPkt(pkt);
            } else {
                av_packet_unref(&pkt);
            }
        } else if (ret == AVERROR_EOF) { // 读取到了文件的尾部
            if (vSize == 0 && aSize == 0) {
                // 说明文件正常播放完毕
                fmtCtxCanFree = true;
                break;
            }
            break;
        } else {
            ERROR_BUF;
            continue;
        }
    }
    if (fmtCtxCanFree) {
        stop();
    } else {
        fmtCtxCanFree = true;
    }
}

void VideoPlayer::free() {
    
}

void VideoPlayer::fataError() {
    
}


void VideoPlayer::play() {
    if (state == Playing) {
        return;
    }
    if (state == Stopped) {
        thread([this]() {
            readFile();
        }).detach();
    } else {
        setState(Playing);
    }
  
}


void VideoPlayer::setUserData(void * userData) {
    this->userData = userData;
}

void VideoPlayer::pause() {
    if (state != Playing) {
        return;
    }
    
}

void VideoPlayer::setState(State state) {
    if (state == this->state) {
        return;
    }
    this->state = state;
    // 通知外部状态状态改变了
}

void VideoPlayer::stop() {
    if (state == Stopped) {
        return;
    }
    state = Stopped;
    free();
    // 通知外界
}

bool VideoPlayer::isPlaying()  {
    return state == Playing;
}

VideoPlayer::State VideoPlayer::getState() {
    return this->state;
}

int VideoPlayer::getDuration() {
    return fmtCtx ?  fmtCtx->duration * av_q2d(AV_TIME_BASE_Q) : 0;
}

int VideoPlayer::getTime() {
    return round(aTime);
}

void VideoPlayer::setTime(int seekTime) {
    this->seekTime = seekTime;
}

void VideoPlayer::setVolumn(int volumn) {
    this->volumn = volumn;
}

int VideoPlayer::getVolumn() {
    return volumn;
}

void VideoPlayer::setMute(bool mute) {
    this->mute = mute;
}

bool VideoPlayer::isMute() {
    return this->mute;
}

/*
音视频同步：
1.视频同步到音频

2.音频同步到视频
*/

/*
1.现实时间
比如一个视频的时长是120秒，其中120秒就是现实时间
比如一个视频播放到了第58秒，其中第58秒就是现实时间

2.FFmpeg时间
1> 时间戳（timestamp），类型是int64_t
2> 时间基（time base\unit），是时间戳的单位，类型是AVRational

3.FFmpeg时间 与 现实时间的转换
1> 现实时间 = 时间戳 * (时间基的分子 / 时间基的分母)
2> 现实时间 = 时间戳 * av_q2d(时间基)
3> 时间戳 = 现实时间 / (时间基的分子 / 时间基的分母)
4> 时间戳 = 现实时间 / av_q2d(时间基)
*/
