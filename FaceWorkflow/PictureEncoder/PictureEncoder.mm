//
//  PictureEncoder.m
//  FaceWorkflow
//
//  Created by lieon on 2021/11/9.
//

#import "PictureEncoder.h"

extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
}

@implementation PictureEncoder

- (void)encode {
    NSString *filePath = @"";
    int inW = 100;
    int inH = 100;
    AVFormatContext *fmtctx = avformat_alloc_context();
    AVOutputFormat *fmt = av_guess_format("mjpeg", NULL, NULL);
    fmtctx->oformat = fmt;
   AVStream *videoSt = avformat_new_stream(fmtctx, 0);
    if (videoSt == NULL) {
        return;
    }
    AVCodecContext *codecCtx = videoSt->codec;
    codecCtx->codec_id = fmt->video_codec;
    codecCtx->codec_type = AVMEDIA_TYPE_VIDEO;
    codecCtx->pix_fmt = AV_PIX_FMT_YUVJ420P;
    codecCtx->width = inW;
    codecCtx->height = inH;
    codecCtx->time_base.num = 1;
    codecCtx->time_base.den = 25;
    
    AVCodec *pcodec = avcodec_find_encoder(codecCtx->codec_id);
    if (!pcodec) {
        return;
    }
    if (avcodec_open2(codecCtx, pcodec, NULL) < 0) {
        return;
    }
    AVFrame *picture = av_frame_alloc();
    int size = avpicture_get_size(codecCtx->pix_fmt, codecCtx->width, codecCtx->height);
    uint8_t *picture_buf = (uint8_t*)av_malloc(size);
    if (!picture_buf) {
        return;
    }
    avpicture_fill((AVPicture*)picture, picture_buf, codecCtx->pix_fmt, codecCtx->width, codecCtx->height);
}
@end
