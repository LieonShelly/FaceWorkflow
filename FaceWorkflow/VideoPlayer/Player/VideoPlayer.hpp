//
//  VideoPlayer.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/7/30.
//

#ifndef VideoPlayer_hpp
#define VideoPlayer_hpp

extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
#include <libswresample/swresample.h>
#include <libswscale/swscale.h>
}
#include <iostream>
#include <string>
#include <stdio.h>
#include <stdint.h>
#include <list>
#include "CondMutex.hpp"

#define ERROR_BUF \
char errbuf[1024]; \
av_strerror(ret, errbuf, sizeof (errbuf));

#define CODE(func, code) \
if (ret < 0) {\
ERROR_BUF;\
std::cout << #func << "error" << errbuf << std::endl; \
code; \
}

#define END(func) CODE(func, fataError(); return;)
#define RET(func) CODE(func, return ret;)
#define CONTINUE(func) CODE(func, continue;)
#define BREAK(func) CODE(func, break;)

using namespace std;

class VideoPlayer {
public:
    VideoPlayer();
    ~VideoPlayer();
    // 状态
    enum State {
        Stopped = 0,
        Playing,
        Paused
    };
    // 音量
    enum Volum {
        Min = 0,
        Max = 100
    };
    // 视频frame参数
    typedef struct {
        int width;
        int height;
        AVPixelFormat pixFmt;
        int size;
    }VideoSwsSpec;
    
    void setFilename(string name);
    void play();
    
private:
    /**音频相关 */
    typedef struct {
        int sampleRate;
        AVSampleFormat sampleFmt;
        int chLayout;
        int chs;
        int bytesPerSampleFrame;
    } AudioSwrSpec;
    // 解码上下文
    AVCodecContext *aDecodeCtx = nullptr;
    // 流
    AVStream *aStream = nullptr;
    // 存放音频包的列表
    list<AVPacket> aPktList;
    // 音频包列表的锁
    CondMutex aMutex;
    // 音频重采言上下文
    SwrContext *aSwrCtx = nullptr;
    // 音频重采样输入输出参数
    AudioSwrSpec aSwrInSpec, aSwrOutSpec;
    // 音频重采样输入输出frame
    AVFrame *aSwrInFrame = nullptr, *aSwrOutFrame = nullptr;
    // 音频重采样输出PCM的索引（从哪个位置开始取出PCM数据填充到SDL的音频缓冲区）
    int aSwrOutIdx = 0;
    // 音频重采样输出PCM的大小
    int aSwrOutSiize = 0;
    // 音频时钟，当前音频包对应的时间值
    double aTime = 0;
    // 音频是否可以释放
    bool aCanFree = false;
    // 外部设置当前播放时刻（用于完成seek功能）
    int aSeekTime = -1;
    // 是否有音频流
    bool hasAudio = false;
    // 初始化音频信息
    int initAudioInfo();
    // 初始化音频重采样
    int initSwr();
    // 初始化SDL
    int initSDL();
    // 添加数据包到音频包列表中
    void addAudioPkt(AVPacket &pkt);
    // 清空音频包列表
    void clearAudioPktList();
    // SDL填充缓冲区的回调函数
    static void sdlAudioCallbackFunc(void *userData, uint8_t *stream, int len);
    // SDL填充缓冲区的回调函数
    void sdlAudioCallback(uint8_t *stream, int len);
    // 音频解码
    int decodeAudio();
    
    
private:
    /**视频相关*/
    // 解码上下文
    AVCodecContext *vDecodeCtx = nullptr;
    // 视频流
    AVStream *vStream = nullptr;
    // 像素格式转换的输入，输出frame
    AVFrame *vSwsInFrame = nullptr, *vSwsOutframe = nullptr;
    // 像素格式装换上下文
    SwsContext *vSwsCtx = nullptr;
    // 像素格式装换输出的frame参数
    VideoSwsSpec vSwsOutSpec;
    // 存放视频包的列表
    list<AVPacket> vPktList;
    // 存放视频包的锁
    CondMutex vMutex;
    // 是否有视频
    bool hasVideo = false;
    // 初始化视频信息
    int initVideoInfo();
    // 初始化像素格式转换
    int initSws();
    // 添加数据包到视频包列表中
    void addVideoPkt(AVPacket &pkt);
    // 清空视频包
    void clearVideoPktList();
    // 解码视频
    void decodeVideo();
    
private:
    // 解封装上下文
    AVFormatContext *fmtCtx = nullptr;
    char filename[512];
    
    void fataError();
    
private:
    void * userData = nullptr;
    using DidDecodeVideoFrame = void (*)(void * userData, VideoPlayer*player, uint8_t *data, VideoSwsSpec outSpec);
    typedef struct PlayerCallback {
        DidDecodeVideoFrame didDecodeVideoFrame = nullptr;
    } Callback;
    
    Callback callback;
    
public:
    // 初始化解码器和解码上下文
    int initDecoder(AVCodecContext **decodecCtx, AVStream**stream, AVMediaType type);
    void readFile();
    void free();
    void setUserData(void * userData);
    void setDecodeVideoFrameCallback(DidDecodeVideoFrame callback);
};

#endif /* VideoPlayer_hpp */
