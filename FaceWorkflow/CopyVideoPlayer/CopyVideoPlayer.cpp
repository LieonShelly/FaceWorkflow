//
//  CopyVideoPlayer.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/11/10.
//

#include "CopyVideoPlayer.hpp"
#include <SDL.h>
#include <thread>

extern "C" {
#include <libavutil/imgutils.h>
}


#define AUDIO_MAX_PKT_SIZE 1000
#define VIDEO_MAX_PKT_SIZE 500

CopyVideoPlayer::CopyVideoPlayer() {
    SDL_SetMainReady();
    if (SDL_Init(SDL_INIT_AUDIO)) {
        return;
    }
}

CopyVideoPlayer::~CopyVideoPlayer() {
    SDL_Quit();
}

int CopyVideoPlayer::initDecoder(AVCodecContext **decodecCtx, AVStream**stream, AVMediaType type) {
    // 根据type寻找到最合适的流信息
    int ret = av_find_best_stream(fmtCtx, type, -1, -1, nullptr, 0);
    RET(av_find_best_stream);
    // 获取流
    int streamIdx = ret;
    *stream = fmtCtx->streams[streamIdx];
    if (!*stream) {
        return -1;
    }
    // 为当前流找到合适的解码器
    AVCodec *decoder = avcodec_find_decoder((*stream)->codecpar->codec_id);
    if (!decoder) {
        return  -1;
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

void CopyVideoPlayer::readFile() {
    int ret = 0;
    ret = avformat_open_input(&fmtCtx, filename, nullptr, nullptr);
    END(avformat_open_input);
    // 检索流信息
    ret = avformat_find_stream_info(fmtCtx, nullptr);
    END(avformat_find_stream_info);
    // 打印流信息
    av_dump_format(fmtCtx, 0, filename, 0);
    fflush(stderr);
    // 初始化音频信息
    hasAudio = initAudioInfo() >= 0;
    hasVideo = initVideoInfo() >= 0;
    cout << "初始化完毕" << endl;
    setState(Playing);
    // 音频编码子线程：开始工作
    SDL_PauseAudio(0);
    // 视频编码子线程：开始工作
    thread([this]() {
        decodeVideo();
    }).detach();
    
    // 从文件中赌气数据
    AVPacket pkt;
    while (state != Stopped) {
        // 处理Seek操作
        if (seekTime >= 0) {
            int streamIdx;
            if (hasAudio) {
                streamIdx = aStream->index;
            } else {
                streamIdx = vStream->index;
            }
            AVRational timebase = fmtCtx->streams[streamIdx]->time_base;
            int64_t ts = seekTime / av_q2d(timebase);
            ret = av_seek_frame(fmtCtx, streamIdx, ts, AVSEEK_FLAG_BACKWARD);
            if (ret < 0) {
                seekTime = -1;
                cout << "Seek 失败" << seekTime << ts << streamIdx << endl;
            } else {
                cout << "Seek 成功" << seekTime << ts << streamIdx << endl;
                vSeekTime = seekTime;
                aSeekTime = seekTime;
                seekTime = -1;
                aTime = 0;
                vTime = 0;
                // 清空之前的读取的数据包
                clearAudioPktList();
                clearVideoPktList();
            }
        }
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
        } else if (ret == AVERROR_EOF) {
            if (vSize == 0 && aSize == 0) {
                break;
            }
        } else {
            ERROR_BUF;
            continue;
        }
    }
}

/*************************音频相关**********************************/
int CopyVideoPlayer::initAudioInfo() {
    // 初始化解码器
    int ret = initDecoder(&aDecodeCtx, &aStream, AVMEDIA_TYPE_AUDIO);
    RET(initDecoder);
    // 初始化音频重采样
    ret = initSwr();
    RET(initDecoder);
    // 初始化SDL
    ret = initSDL();
    RET(initSDL);
    return 0;
}

int CopyVideoPlayer::initSwr() {
    // 设置重采样输入参数
    aSwrInSpec.sampleFmt = aDecodeCtx->sample_fmt;
    aSwrInSpec.sampleRate = aDecodeCtx->sample_rate;
    aSwrInSpec.chLayout = (int)aDecodeCtx->channel_layout;
    aSwrInSpec.chs = aDecodeCtx->channels;
    // 设置重采样输出参数
    aSwrOutSpec.sampleFmt = AV_SAMPLE_FMT_S16;
    aSwrOutSpec.sampleRate = 44100;
    aSwrOutSpec.chLayout = AV_CH_LAYOUT_STEREO;
    aSwrOutSpec.chs = av_get_channel_layout_nb_channels(aSwrOutSpec.chLayout);
    aSwrOutSpec.bytesPerSampleFrame = aSwrOutSpec.chs * av_get_bytes_per_sample(aSwrOutSpec.sampleFmt);
    // 创建重采样上下文
    aSwrCtx = swr_alloc_set_opts(nullptr,
                                 // 输出参数
                                 aSwrOutSpec.chLayout,
                                 aSwrOutSpec.sampleFmt,
                                 aSwrOutSpec.sampleRate,
                                 // 输入参数
                                 aSwrInSpec.chLayout,
                                 aSwrInSpec.sampleFmt,
                                 aSwrInSpec.sampleRate,
                                 0, nullptr);
    if (!aSwrCtx) {
        cout << "swr_alloc_set_opts error" << endl;
        return -1;
    }
    // 初始化重采样上下文
    int ret = swr_init(aSwrCtx);
    RET(swr_init);
    // 初始化重采样的输入frame
    aSwrOutFrame = av_frame_alloc();
    if (!aSwrOutFrame) {
        cout << "av_frame_alloc error" << endl;
        return -1;
    }
    // 初始化重采样的输出frame
    aSwrInFrame = av_frame_alloc();
    if (!aSwrInFrame) {
        cout << "av_frame_alloc error" << endl;
        return -1;
    }
    // 为aSwrOutFrame的data[0]分配内存空间
    ret = av_samples_alloc(aSwrOutFrame->data,
                           aSwrOutFrame->linesize,
                           aSwrOutSpec.chs,
                           4096, aSwrOutSpec.sampleFmt, 1);
    RET(av_samples_alloc)
    return 0;
}

int CopyVideoPlayer::initSDL() {
    // 音频参数
    SDL_AudioSpec spec;
    // 采样率
    spec.freq = aSwrInSpec.sampleRate;
    // 采样格式
    spec.format = AUDIO_S16LSB;
    // 声道数
    spec.channels = aSwrOutSpec.chs;
    // 音频缓冲区的样本数量
    spec.samples = 512;
    // 传递给回调的参数
    spec.userdata = this;
    // 回调
    spec.callback = sdlAudioCallbackFunc;
    // 打开音频设备
    if (SDL_OpenAudio(&spec, nullptr)) {
        return -1;
    }
    return 0;
}

void CopyVideoPlayer::addAudioPkt(AVPacket &pkt) {
    aMutex.lock();
    aPktList.push_back(pkt);
    aMutex.signal();
    aMutex.unlock();
}

void CopyVideoPlayer::clearAudioPktList() {
    aMutex.lock();
    for (AVPacket &pkt: aPktList) {
        av_packet_unref(&pkt);
    }
    aPktList.clear();
    aMutex.unlock();
}

void CopyVideoPlayer::sdlAudioCallbackFunc(void *userData, uint8_t *stream, int len) {
    CopyVideoPlayer *player = (CopyVideoPlayer*)userData;
    player->sdlAudioCallback(stream, len);
}

void CopyVideoPlayer::sdlAudioCallback(uint8_t *stream, int len) {
    // 静音处理
    SDL_memset(stream, 0, len);
    //len: SDL音频缓冲区剩余的大小（还未填充的大小）
    while (len > 0) {
        if (state == Paused) {
            break;
        }
        if (state == Stopped) {
            aCanFree = true;
            break;
        }
        // 说明当前PCM的数据已经全部拷贝到SDL的音频缓冲区了，需要解码下一个pkt，获取新的PCM数据
        if (aSwrOutIdx >= aSwrOutSiize) {
            // 新的PCM的大小
            aSwrOutSiize = decodeAudio();
            // 索引清0
            aSwrOutIdx = 0;
            // 没有解码出PCM数据，那就静音处理
            if (aSwrOutSiize <= 0) {
                aSwrOutSiize = 1024;
                memset(aSwrOutFrame->data[0], 0, aSwrOutSiize);
            }
        }
        // 本次需要填充到stream中的PCM的数据大小
        int fillLen = aSwrOutSiize - aSwrOutIdx;
        fillLen = min(fillLen, len);
        // 获取当前音量
        int volumn = mute ? 0 : (this->volumn * 1.0 / Max) * SDL_MIX_MAXVOLUME;
        // 填充SDL缓冲区
        SDL_MixAudio(stream, aSwrOutFrame->data[0] + aSwrOutIdx, fillLen, volumn);
        // 移动偏移量
        len -= fillLen;
        stream += fillLen;
        aSwrOutIdx += fillLen;
    }
}

int CopyVideoPlayer::decodeAudio() {
    aMutex.lock();
    if (aPktList.empty()) {
        aMutex.unlock();
        return 0;
    }
    AVPacket pkt = aPktList.front();
    aPktList.pop_front();
    aMutex.unlock();
    //保存音频时钟
    if (pkt.pts != AV_NOPTS_VALUE) {
        aTime = av_q2d(aStream->time_base) * pkt.pts;
        // 通知外界：播放时间点发生了改变
        if (callback.timeChanged) {
            callback.timeChanged(userData, this);
        }
        // 发现音频的时间是早于seektime的，直接丢弃
        if (aSeekTime >= 0) {
            if (aTime < aSeekTime) {
                av_packet_unref(&pkt);
                return 0;
            } else {
                aSeekTime = -1;
            }
        }
    }
    // 发送数据到解码器
    int ret = avcodec_send_packet(aDecodeCtx, &pkt);
    av_packet_unref(&pkt);
    RET(avcodec_send_packet);
    // 从解码器中获取之后的数据到输入frame
    ret = avcodec_receive_frame(aDecodeCtx, aSwrInFrame);
    if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
        return 0;
    } else RET(avcodec_receive_frame);
    // 重采样的输出样本数
    int outSamples = (int)av_rescale_rnd(aSwrOutSpec.sampleRate, aSwrInFrame->nb_samples, aSwrInSpec.sampleRate, AV_ROUND_UP);
    // 由于解码出来的PCM，跟SDL要求的PCM格式可能不一致，所以需要重采样
    ret = swr_convert(aSwrCtx,
                      aSwrOutFrame->data,
                      outSamples,
                      (const uint8_t**)aSwrInFrame->data,
                      aSwrInFrame->nb_samples);
    RET(swr_convert)
    return ret * aSwrOutSpec.bytesPerSampleFrame;
}


void CopyVideoPlayer::freeAudio() {
    aTime = 0;
    aSwrOutIdx = 0;
    aSwrOutSiize = 0;
    aStream = nullptr;
    aCanFree = false;
    aSeekTime = -1;
    
    clearAudioPktList();
    avcodec_free_context(&aDecodeCtx);
    swr_free(&aSwrCtx);
    av_frame_free(&aSwrInFrame);
    if (aSwrOutFrame) {
        av_freep(&aSwrOutFrame->data[0]);
        av_frame_free(&aSwrOutFrame);
    }
    
    SDL_PauseAudio(1);
    SDL_CloseAudio();
}

/*************************视频相关**********************************/

int CopyVideoPlayer::initVideoInfo() {
    // 初始化解码器
    int ret = initDecoder(&vDecodeCtx, &vStream, AVMEDIA_TYPE_VIDEO);
    RET(initDecoder);
    // 初始化像素合格式转换
    ret = initSwr();
    RET(initSwr);
    return 0;
}

int CopyVideoPlayer::initSws() {
    int inW = vDecodeCtx->width;
    int inH = vDecodeCtx->height;
    
    // 输出参数
    vSwsOutSpec.width = inW >> 4 << 4;
    vSwsOutSpec.height = inH >> 4 << 4;
    vSwsOutSpec.pixFmt = AV_PIX_FMT_RGB24;
    vSwsOutSpec.size = av_image_get_buffer_size(vSwsOutSpec.pixFmt, vSwsOutSpec.width, vSwsOutSpec.height, 1);
    // 初始化像素格式转换的上下文
    vSwsCtx = sws_getContext(inW, inH,
                             vDecodeCtx->pix_fmt,
                             vSwsOutSpec.width,
                             vSwsOutSpec.height,
                             vSwsOutSpec.pixFmt,
                             SWS_BILINEAR, nullptr, nullptr, nullptr);
    if (!vSwsCtx) {
        return -1;
    }
    // 初始化像素格式装换的输入frame
    vSwsInFrame = av_frame_alloc();
    // 初始化像素格式装换的输出frame
    vSwsOutframe = av_frame_alloc();
    // 给输出缓冲区_vSwsOuframe的data分配内存空间
    int ret = av_image_alloc(vSwsOutframe->data, vSwsOutframe->linesize, vSwsOutSpec.width, vSwsOutSpec.height, vSwsOutSpec.pixFmt, 1);
    RET(av_image_alloc);
    return 0;
}

void CopyVideoPlayer::addVideoPkt(AVPacket &pkt) {
    vMutex.lock();
    vPktList.push_back(pkt);
    vMutex.signal();
    vMutex.unlock();
}

void CopyVideoPlayer::clearVideoPktList() {
    vMutex.lock();
    for (AVPacket &pkt : vPktList) {
        av_packet_unref(&pkt);
    }
    vPktList.clear();
    vMutex.unlock();
}


void CopyVideoPlayer::freeVideo() {
    clearVideoPktList();
    avcodec_free_context(&vDecodeCtx);
    av_frame_free(&vSwsInFrame);
    if (vSwsOutframe) {
        av_freep(&vSwsOutframe->data[0]);
        av_frame_free(&vSwsOutframe);
    }
    sws_freeContext(vSwsCtx);
    vSwsCtx = nullptr;
    vStream = nullptr;
    vTime = 0;
    vCanFree = false;
    vSeekTime = -1;
}


void CopyVideoPlayer::decodeVideo() {
    while (true) {
        // 如果是暂停，并且没有Seek操作
        if (state == Paused && vSeekTime == -1) {
            continue;
        }
        if (state == Stopped) {
            vCanFree = true;
            break;
        }
        vMutex.lock();
        if (vPktList.empty()) {
            vMutex.unlock();
            continue;
        }
        // 取出头部的视频包
        AVPacket pkt = vPktList.front();
        vPktList.pop_front();
        vMutex.unlock();
        // 视频时钟
        if (pkt.dts != AV_NOPTS_VALUE) {
            vTime = av_q2d(vStream->time_base) * pkt.dts;
        }
        // 发送数据到解码器
        int ret = avcodec_send_frame(vDecodeCtx, vSwsInFrame);
        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
            break;
        } else BREAK(avcodec_receive_frame);
        // 一定要在解码成功后，再进行下面的判断
        // 发现视频的时间早于seektime的，直接丢弃
        if (vSeekTime > 0) {
            if (vTime < vSeekTime) {
                continue;
            } else {
                vSeekTime = -1;
            }
        }
        // 像素格式转换
        sws_scale(vSwsCtx,
                  vSwsInFrame->data,
                  vSwsInFrame->linesize,
                  0,
                  vDecodeCtx->height,
                  vSwsOutframe->data,
                  vSwsOutframe->linesize);
        if (hasAudio) {// 有音频
            //音频同步视频 如果视频包过早被解码出来，那就需要等待对应的音频时钟到达
            while (vTime > aTime && state == Playing) {
                SDL_Delay(5);
            }
        } else {
            // TODO
        }
        // 把像素格式转换后的图片数据，拷贝一份出来
        uint8_t *data = (uint8_t*)av_malloc(vSwsOutSpec.size);
        memcpy(data, vSwsOutframe->data[0], vSwsOutSpec.size);
        // 回调给外部进行渲染
        cout << "渲染了一帧" << vSwsOutframe->pts << " 剩余包数量：" << vPktList.size() << endl;
        if (callback.didDecodeVideoFrame) {
            callback.didDecodeVideoFrame(this->userData, this, data, vSwsOutSpec);
        } else {
            delete data;
            data = nullptr;
        }
    }
}
