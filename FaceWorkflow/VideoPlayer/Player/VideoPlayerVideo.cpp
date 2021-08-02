//
//  VideoPlayerVideo.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/8/1.
//

#include <stdio.h>
#include "VideoPlayer.hpp"
extern "C" {
#include <libavutil/imgutils.h>
}

int VideoPlayer::initVideoInfo() {
    // 初始化解码器
    int ret = initDecoder(&vDecodeCtx, &vStream, AVMEDIA_TYPE_VIDEO);
    RET(initDecoder);

    // 初始化像素格式装换
    ret = initSws();
    RET(initSws)
    return 0;
}

int VideoPlayer::initSws() {
    int inW = vDecodeCtx->width;
    int inH = vDecodeCtx->height;
    
    // 输出参数
    vSwsOutSpec.width = inW >> 4 << 4;
    vSwsOutSpec.height = inH >> 4 << 4;
    vSwsOutSpec.pixFmt = AV_PIX_FMT_RGB24;
    vSwsOutSpec.size = av_image_get_buffer_size(vSwsOutSpec.pixFmt, vSwsOutSpec.width, vSwsOutSpec.height, 1);
    // 初始化像素格式转换的上下文
    vSwsCtx = sws_getContext(inW,
                             inH,
                             vDecodeCtx->pix_fmt,
                             vSwsOutSpec.width,
                             vSwsOutSpec.height,
                             vSwsOutSpec.pixFmt,
                             SWS_BILINEAR, nullptr, nullptr, nullptr);
    if (!vSwsCtx) {
        return -1;
    }
    // 初始化像素格式转换的输出frame
    vSwsInFrame = av_frame_alloc();
    // 初始化像素格式转换的输出frame
    vSwsOutframe = av_frame_alloc();
    // 给输出缓冲区_vSwsOutFrame的data分配内存空间
    int ret = av_image_alloc(vSwsOutframe->data, vSwsOutframe->linesize, vSwsOutSpec.width, vSwsOutSpec.height, vSwsOutSpec.pixFmt, 1);
    RET(av_image_alloc);
    return 0;
}

void VideoPlayer::addVideoPkt(AVPacket &pkt) {
    vMutex.lock();
    vPktList.push_back(pkt);
    vMutex.signal();
    vMutex.unlock();
}

void VideoPlayer::clearVideoPktList() {
    vMutex.lock();
    for (AVPacket &pkt : vPktList) {
        av_packet_unref(&pkt);
    }
    vPktList.clear();
    vMutex.unlock();
}

void VideoPlayer::decodeVideo() {
    while (true) {
        vMutex.lock();
        if (vPktList.empty()) {
            vMutex.unlock();
            continue;
        }
        // 取出头部的视频包
        AVPacket pkt = vPktList.front();
        vPktList.pop_front();
        vMutex.unlock();
        // 发送数据到解码器
        int ret = avcodec_send_packet(vDecodeCtx, &pkt);
        // 释放pkt
        av_packet_unref(&pkt);
        CONTINUE(avcodec_send_packet);
        while (true) {
            ret = avcodec_receive_frame(vDecodeCtx, vSwsInFrame);
            if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
                break;
            } else BREAK(avcodec_receive_frame);
            
            // 像素格式装换
            sws_scale(vSwsCtx,
                      vSwsInFrame->data,
                      vSwsInFrame->linesize,
                      0,
                      vDecodeCtx->height,
                      vSwsOutframe->data,
                      vSwsOutframe->linesize);
            // 把像素格式转换后的图片数据，拷贝一份出来
            uint8_t *data = (uint8_t*)av_malloc(vSwsOutSpec.size);
            memcpy(data, vSwsOutframe->data[0], vSwsOutSpec.size);
            // 回调给外部进行渲染
            cout << "渲染了一帧" << vSwsOutframe->pts << " 剩余包数量：" << vPktList.size() << endl;
            if (callback.didDecodeVideoFrame) {
                callback.didDecodeVideoFrame(this->userData, this, data, vSwsOutSpec);
            }
        }
    }
}

void VideoPlayer::setDecodeVideoFrameCallback(DidDecodeVideoFrame callback) {
    this->callback.didDecodeVideoFrame = callback;
}
