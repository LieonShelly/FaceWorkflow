//
//  VideoPlayerAudio.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/7/30.
//

#include "VideoPlayer.hpp"

int VideoPlayer::initAudioInfo() {
    // 初始化解码器
    int ret = initDecoder(&aDecodeCtx, &aStream, AVMEDIA_TYPE_AUDIO);
    RET(initDecoder);
    // 初始化音频重采样
    ret = initSwr();
    RET(initSwr);
    // 初始化SDL
    ret = initSDL();
    RET(initSDL);
    return 0;
}

int VideoPlayer::initSwr() {
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

int VideoPlayer::initSDL() {
    // 音频参数
    SDL_AudioSpec spec;
    // 采样率
    spec.freq = aSwrOutSpec.sampleRate;
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
        cout << "SDL_OpenAudio error" << endl;
        return -1;
    }
    return 0;
}

void VideoPlayer::addAudioPkt(AVPacket &pkt) {
    aMutex.lock();
    aPktList.push_back(pkt);
    aMutex.signal();
    aMutex.unlock();
}

void VideoPlayer::clearAudioPktList() {
    aMutex.lock();
    for (AVPacket &pkt: aPktList) {
        av_packet_unref(&pkt);
    }
    aPktList.clear();
    aMutex.unlock();
}

void VideoPlayer::sdlAudioCallbackFunc(void *userData, uint8_t *stream, int len) {
    VideoPlayer *player = (VideoPlayer*)userData;
    player->sdlAudioCallback(stream, len);
}

void VideoPlayer::sdlAudioCallback(uint8_t *stream, int len) {
    // 清零（静音）
    SDL_memset(stream, 0, len);
    // len: SDL音频缓冲区剩余的大小（还未填充的大小）
    while (len > 0) {
        if (state == Paused) {
            break;
        }
        if (state == Stopped) {
            aCanFree = true;
            break;
        }
        // 说明当前PCM的数据已经全部拷贝到SDL的音频缓冲区了
        // 需要解码下一个pkt，获取新的PCM数据
        if (aSwrOutIdx >= aSwrOutSiize) {
            // 新的PCM的大小
            aSwrOutSiize = decodeAudio();
            // 索引清0
            aSwrOutIdx = 0;
            // 没有解码出PCM数据，那就静音处理
            if (aSwrOutSiize <= 0) {
                // 假定PCM的大小
                aSwrOutSiize = 1024;
                // 给PCM填充0（静音）
                memset(aSwrOutFrame->data[0], 0, aSwrOutSiize);
            }
        }
        // 本次需要填充到stream中的PCM的数据大小
        int fillLen = aSwrOutSiize - aSwrOutIdx;
        fillLen = min(fillLen, len);
        
        // 获取当期音量
        // 填充SDL缓冲区
        SDL_MixAudio(stream,
                     aSwrOutFrame->data[0] + aSwrOutIdx,
                     fillLen, SDL_MIX_MAXVOLUME);
        // 移动偏移量
        len -= fillLen;
        stream += fillLen;
        aSwrOutIdx += fillLen;
        
        cout << "SDL_MixAudio fillLen:" << fillLen << " aSwrOutIdx: " << aSwrOutIdx << " aSwrOutSiize: " << aSwrOutSiize << " len: " << len << endl;
    }
    cout << "len <= 0" << endl;
}

int VideoPlayer::decodeAudio() {
    // 加锁
    aMutex.lock();
    if (aPktList.empty()) {
        aMutex.unlock();
        return 0;
    }
    AVPacket pkt = aPktList.front();
    aPktList.pop_front();
    cout << "list cout: " << aPktList.size() << endl;
    aMutex.unlock();
    // 保存音频时钟
    if (pkt.pts != AV_NOPTS_VALUE) {
        aTime = av_q2d(aStream->time_base) * pkt.pts;
        // 通知外界：播放时间点发生了改变
    }
    // 如果是视频，不能在这个位置判断（不能提前释放pkt，不然会导致B帧。P帧解码失败，画面直接撕裂）
    // 发现音频的时间是早于seektime的，直接丢弃
    if (aSeekTime >= 0) {
        if (aTime < aSeekTime) {
            // 释放pkt
            av_packet_unref(&pkt);
            return 0;
        } else {
            aSeekTime = -1;
        }
    }
    
    // 发送数据到解码器
    int ret = avcodec_send_packet(aDecodeCtx, &pkt);
    av_packet_unref(&pkt);
    RET(avcodec_send_packet);
    ret = avcodec_receive_frame(aDecodeCtx, aSwrInFrame);
    if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
        return 0;
    } else RET(avcodec_receive_frame);
    // 重采样输出的样本数
    int outSamples = (int)av_rescale_rnd(aSwrOutSpec.sampleRate,
                                    aSwrInFrame->nb_samples,
                                    aSwrInSpec.sampleRate, AV_ROUND_UP);
    // 由于解码出来的PCM，跟SDL要求的PCM格式可能不一致
    // 所以需要需要重采样
    ret = swr_convert(aSwrCtx,
                      aSwrOutFrame->data,
                      outSamples,
                      (const uint8_t**)aSwrInFrame->data,
                      aSwrInFrame->nb_samples);
    RET(swr_convert)
    return ret * aSwrOutSpec.bytesPerSampleFrame;
}
