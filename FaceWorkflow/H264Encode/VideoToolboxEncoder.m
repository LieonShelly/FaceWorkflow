//
//  VideoToolboxEncoder.m
//  FaceWorkflow
//
//  Created by lieon on 2021/8/4.
//

#import "VideoToolboxEncoder.h"
#include <VideoToolbox/VideoToolbox.h>

@interface VideoToolboxEncoder()
{
    VTCompressionSessionRef encodeSession;
}
@end

@implementation VideoToolboxEncoder

/**
 typedef void (*VTCompressionOutputCallback)(
 void * CM_NULLABLE outputCallbackRefCon,
 void * CM_NULLABLE sourceFrameRefCon,
 OSStatus status,
 VTEncodeInfoFlags infoFlags,
 CM_NULLABLE CMSampleBufferRef sampleBuffer )
 
 */
/**
 sampleBuffer 编码后的数据
 */
void compressCallback(void * outputCallbackRefCon,
                      void * CM_NULLABLE sourceFrameRefCon,
                      OSStatus status,
                      VTEncodeInfoFlags infoFlags,
                      CM_NULLABLE CMSampleBufferRef sampleBuffer ) {
    if (status != 0) {
        return;
    }
    if (!CMSampleBufferDataIsReady(sampleBuffer)) {
        return;
    }
    // 判断当前帧是否为关键帧 sps/pps信息
    
    bool keyframe = CFDictionaryContainsKey(
                                            CFArrayGetValueAtIndex(
                                                                   CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true),
                                                                   0),
                                            kCMSampleAttachmentKey_NotSync);
    if (keyframe) {
        
    }
}

- (void)initEncoder {
    CGSize videoSize = CGSizeMake(444, 444);
    OSStatus status = VTCompressionSessionCreate(NULL, // 分配器
                                                 videoSize.width,
                                                 videoSize.height,
                                                 kCMVideoCodecType_H264,
                                                 NULL, // 编码规范
                                                 NULL, // 源像素缓冲区
                                                 NULL, // 压缩数据分配器
                                                 compressCallback,
                                                 (__bridge void*)self,
                                                 &encodeSession);
    if (status) {
        
    }
    // 配置参数
    // 实时编码
    VTSessionSetProperty(encodeSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
    // 舍弃B帧
    VTSessionSetProperty(encodeSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_AutoLevel);
    // GOP
    int frameInterval = 30;
    CFNumberRef frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
    VTSessionSetProperty(encodeSession, kVTCompressionPropertyKey_MaxKeyFrameInterval, frameIntervalRef);
    // 帧率
    int fps = 30;
    CFNumberRef fpsRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &fps);
    VTSessionSetProperty(encodeSession, kVTCompressionPropertyKey_ExpectedFrameRate, fpsRef);
    // 码率上限
    int bitRate = videoSize.width * videoSize.height * 4 * 3 * 8;
    CFNumberRef bitRateRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &bitRate);
    VTSessionSetProperty(encodeSession, kVTCompressionPropertyKey_AverageBitRate , bitRateRef);
    
    // 码率
    int biteRateLimit = videoSize.width * videoSize.height * 4 * 3 * 8;
    CFNumberRef biteRateLimitRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &biteRateLimit);
    VTSessionSetProperty(encodeSession, kVTCompressionPropertyKey_DataRateLimits, biteRateLimitRef);
    
    // 准备开始编码
    VTCompressionSessionPrepareToEncodeFrames(encodeSession);
}

- (void)encode:(CMSampleBufferRef)sampleBuffer {
    static int fremeId = 0;
    // 获取未编码的视频帧
    CVImageBufferRef imgbuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    // 帧时间
    CMTime ptime = CMTimeMake(fremeId++, 1000);
    VTEncodeInfoFlags flags;
    OSStatus status = VTCompressionSessionEncodeFrame(encodeSession,
                                                      imgbuffer,
                                                      ptime,
                                                      kCMTimeInvalid,
                                                      NULL,
                                                      NULL,
                                                      &flags);
    if (status != 0) {
        // 结束编码
        VTCompressionSessionInvalidate(encodeSession);
        CFRelease(encodeSession);
        encodeSession = NULL;
        return;
    }
    // 编码成功
}
@end
