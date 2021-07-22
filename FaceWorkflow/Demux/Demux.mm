//
//  Demux.m
//  FaceWorkflow
//
//  Created by lieon on 2021/7/22.
//

#import "Demux.h"

extern "C" {
#include <libavutil/imgutils.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavutil/avutil.h>
}

#define ERROR_BUF \
char errbuf[1024]; \
av_strerror(ret, errbuf, sizeof (errbuf));

#define END(func) \
if (ret < 0) { \
ERROR_BUF; \
NSLog(@"%s error %s",#func, errbuf);\
goto end; \
}

#define RET(func) \
if (ret < 0) { \
ERROR_BUF; \
NSLog(@"%s error %s",#func, errbuf);\
return ret; \
}

@interface Demux()
{
    AVFormatContext *_fmtCtx;
    AVCodecContext *_aDecodeCtx;
    AVCodecContext *_vDecodeCtx;
    AVFrame *_frame;
    int _aStreamIdx;
    int _vStreamIdx;
    NSFileHandle *aOutFile;
    NSFileHandle *vOutFile;
}
@property (nonatomic, strong) AudioDecodeSpec *aOut;
@property (nonatomic, strong) VideoDecodeSpec *vOut;


@end

@implementation Demux

- (void)demux:(NSString *)infileName outAudioParam:(AudioDecodeSpec *)aOut outVideooParam:(VideoDecodeSpec *)vOut {
    self.aOut = aOut;
    self.vOut = vOut;
    AVPacket *packet = nullptr;
    int ret = 0;
    __weak typeof(self) weakSelf = self;
    [[NSFileManager defaultManager]createFileAtPath:self.aOut.filename contents:nil attributes:nil];
    [[NSFileManager defaultManager]createFileAtPath:self.vOut.filename contents:nil attributes:nil];
    aOutFile = [NSFileHandle fileHandleForWritingAtPath:self.aOut.filename];
    vOutFile = [NSFileHandle fileHandleForWritingAtPath:self.vOut.filename];
    
    // 创建解封装上下文
    ret = avformat_open_input(&_fmtCtx, infileName.UTF8String, nullptr, nullptr);
    END(avformat_open_input);
    
    // 检索流信息
    ret = avformat_find_stream_info(_fmtCtx, nullptr);
    END(avformat_find_stream_info);
    
    // 打印流信息到控制台
    av_dump_format(_fmtCtx, 0, infileName.UTF8String, 0);
    fflush(stderr);
    
    // 初始化音频信息
    ret = [self initAudionInfo];
    if (ret < 0) {
        goto end;
    }
    // 初始化视频信息
    ret = [self initVideoInfo];
    if (ret < 0) {
        goto end;
    }
    // 初始化frame
    _frame = av_frame_alloc();
    if (!_frame) {
        goto end;
    }
    // 初始化pkt
    packet = av_packet_alloc();
    packet->data = nullptr;
    packet->size = 0;
    
    // 从输入文件中读取数据
    while (av_read_frame(_fmtCtx, packet) == 0) {
        if (packet->stream_index == _aStreamIdx) {
            ret = [self decode:_aDecodeCtx packet:packet func:^{
                [weakSelf writeAudioFrame];
            }];
        } else if (packet->stream_index == _vStreamIdx) {
            ret = [self decode:_vDecodeCtx packet:packet func:^{
                [weakSelf writeVideoFrame];
            }];
        }
        av_packet_unref(packet);
        if (ret < 0) {
            goto end;
        }
    }
    // 刷新缓冲区
    {
        [self decode:_aDecodeCtx packet:nullptr func:^{
            [self writeAudioFrame];
        }];
        [self decode:_vDecodeCtx packet:nullptr func:^{
            [weakSelf writeVideoFrame];
        }];
    }
end:
    NSLog(@"-----end----");
    [aOutFile closeFile];
    [vOutFile closeFile];
    avcodec_free_context(&_aDecodeCtx);
    avcodec_free_context(&_vDecodeCtx);
    avformat_close_input(&_fmtCtx);
    av_frame_free(&_frame);
    av_packet_free(&packet);
}

// 初始化音频信息
- (int)initAudionInfo {
    return 1;
}


// 初始化视频信息
- (int)initVideoInfo {
    return 1;
}

// 初始化解码器
- (int)initDecoder:(AVCodecContext**)decodeCtx streamIdx:(int *)streamIdx mediaType:(AVMediaType)type {
    return 0;
}

int test(int a) {
    return 1;
}

// 解码
- (int)decode: (AVCodecContext *)decodeCtx packet:(AVPacket*)pkt func: (void(^)())handler {
    // 发送压缩数据到解码器
    int ret = avcodec_send_packet(decodeCtx, pkt);
    RET(avcodec_send_packet);
    while (true) {
        // 获取解码后的数据
        ret = avcodec_receive_frame(decodeCtx, _frame);
        if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
            return 0;
        }
        RET(avcodec_receive_frame);
        // 执行写入文件的代码
        handler();
    }
    return 1;
}


- (void)writeVideoFrame {
    
}

- (void)writeAudioFrame {
    
}

@end
