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
    int _sampleSize;
    // 每个音频样本帧的大小（包含左右声道）
    int _sampleFrameSize;
    uint8_t *_imgBuf[4];
    int _imageLinesizes[4];
    int _imgSize;
}
@property (nonatomic, strong) AudioDecodeSpec *aOut;
@property (nonatomic, strong) VideoDecodeSpec *vOut;
@end

@implementation Demux

// ffmpeg -c:v h264 -c:a libfdk_aac -i in.mp4 cmd_out.yuc -f s16le cmd_out.pcm

- (void)demux:(NSString *)infileName outAudioParam:(AudioDecodeSpec *)aOut outVideooParam:(VideoDecodeSpec *)vOut {
    self.aOut = aOut;
    self.vOut = vOut;
    AVPacket *packet = nullptr;
    int ret = 0;
    __weak typeof(self) weakSelf = self;

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
            [weakSelf writeAudioFrame];
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
    av_freep(_imgBuf[0]);
}

// 初始化音频信息
- (int)initAudionInfo {
    int ret = [self initDecoder:&_aDecodeCtx streamIdx:&_aStreamIdx mediaType:AVMEDIA_TYPE_AUDIO];
    RET(initDecoder);
    [[NSFileManager defaultManager]createFileAtPath:self.aOut.filename contents:nil attributes:nil];
    aOutFile = [NSFileHandle fileHandleForWritingAtPath:self.aOut.filename];
    // 保存音频参数
    _aOut.sampleRate = _aDecodeCtx->sample_rate;
    _aOut.sampleFmt = _aDecodeCtx->sample_fmt;
    _aOut.chLayout = (int)_aDecodeCtx->channel_layout;
    // 音频样本帧的大小
    _sampleSize = av_get_bytes_per_sample((AVSampleFormat)_aOut.sampleFmt);
    _sampleFrameSize = _sampleSize * _aDecodeCtx->channels;
    return 0;
}

// 初始化视频信息
- (int)initVideoInfo {
    int ret = [self initDecoder:&_vDecodeCtx streamIdx:&_vStreamIdx mediaType:AVMEDIA_TYPE_VIDEO];
    RET(initDecoder);
    [[NSFileManager defaultManager]createFileAtPath:self.vOut.filename contents:nil attributes:nil];
    vOutFile = [NSFileHandle fileHandleForWritingAtPath:self.vOut.filename];
    if (!vOutFile) {
        return -1;
    }
    // 保存视频参数
    _vOut.width = _vDecodeCtx->width;
    _vOut.height = _vDecodeCtx->height;
    _vOut.pixFmt = _vDecodeCtx->pix_fmt;
    // 帧率
    AVRational frameRate = av_guess_frame_rate(_fmtCtx, _fmtCtx->streams[_vStreamIdx], nullptr);
    _vOut.fps = frameRate.num / frameRate.den;
    // 创建用于存放一帧解码图片的缓冲区
    ret = av_image_alloc(_imgBuf, _imageLinesizes, _vOut.width , _vOut.height, (AVPixelFormat)_vOut.pixFmt, 1);
    RET(av_image_alloc);
    _imgSize = ret;
    return 0;
}

// 初始化解码器
- (int)initDecoder:(AVCodecContext**)decodeCtx streamIdx:(int *)streamIdx mediaType:(AVMediaType)type {
    // 根据Type寻找最合适的流信息
    // 返回值是流索引
    int ret = av_find_best_stream(_fmtCtx, type, -1, -1, nullptr, 0);
    RET(av_find_best_stream);
    // 检验流
    *streamIdx = ret;
    AVStream *stream = _fmtCtx->streams[*streamIdx];
    if (!stream) {
        return -1;
    }
    // 为当前流找到合适的解码器
    AVCodec *decoder = avcodec_find_decoder(stream->codecpar->codec_id);
    if (!decoder) {
        return -1;
    }
    // 初始化解码器上下文
    *decodeCtx = avcodec_alloc_context3(decoder);
    if (!decodeCtx) {
        return -1;
    }
    // 从流中拷贝参数到解码器上下文中
    ret = avcodec_parameters_to_context(*decodeCtx, stream->codecpar);
    RET(avcodec_parameters_to_context);
    // 打开解码器
    ret = avcodec_open2(*decodeCtx, decoder, nullptr);
    RET(avcodec_open2);
    return 0;
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
    av_image_copy(_imgBuf,
                  _imageLinesizes,
                  (const uint8_t**)_frame->data,
                  _frame->linesize,
                  (AVPixelFormat)_vOut.pixFmt,
                  _vOut.width,
                  _vOut.height);
    // 将缓冲区的数据写入文件
    [vOutFile writeData:[NSData dataWithBytes:_imgBuf[0] length:_imgSize]];
    
}

- (void)writeAudioFrame {
    // libfdk_aac解码器，解码出来的PCM格式：s16
    // aac解码器，解码出来的PCM格式：ftlp
    /**
     - planar的内存布局(左右声道隔离的)
        - LLLLLLLLLLL RRRRRRRRRRRR
     - 非planar的内存布局
        - LR LR LR
     */
    if (av_sample_fmt_is_planar((AVSampleFormat)_aOut.sampleFmt)) {
        // planar格式写入文件时，以非planar写入，这样ffplay才能正确播放
        //  LLLL RRRR DDDD FFFF
        // 外层循环：每一个声道的样本数
        for (int si = 0; si < _frame->nb_samples; si++) {
            // 内层循环：有多少个声道
            for (int ci = 0; ci < _aDecodeCtx->channels; ci++) {
                char *begin = (char*)(_frame->data[ci] + si * _sampleSize);
                [aOutFile writeData:[NSData dataWithBytes:begin length:_sampleSize]];
            }
        }
    } else {
        [aOutFile writeData:[NSData dataWithBytes:_frame->data[0] length:_frame->nb_samples * _sampleFrameSize]];
        
        // _aOutFile.write((char *) _frame->data[0], _frame->linesize[0]);
        // 不用这句话的原因是：linesize[0]的值是始终固定的，但是在最后几帧的时候，样本数不一定能填满整个frame
    }
}

@end
