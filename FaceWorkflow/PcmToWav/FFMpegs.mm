//
//  FFMpegs.m
//  FaceWorkflow
//
//  Created by lieon on 2021/6/22.
//

#import "FFMpegs.h"

@implementation FFMpegs

+ (void)pcm2wav:(WavHeader *)header pcmfile:(NSString *)pcmFilename wavfile:(NSString *)wavfilename {
    // 一个样本的字节数
    header->blockAlign = header->bitPerSample * header->numChannels >> 3;
    // 字节数
    header->byteRate = header->sampleRate * header->blockAlign;
    // 打开pcm文件
    NSFileHandle *pcmhandle = [NSFileHandle fileHandleForReadingAtPath:pcmFilename];
    if (!pcmhandle) {
        NSLog(@"PCM文件打开失败");
        return;
    }
    header->dataChunkSize = (uint32_t)pcmhandle.availableData.length;
    header->riffChunkSize = header->dataChunkSize + sizeof(WavHeader) - sizeof(header->riffChunkId) - sizeof(header->riffChunkSize);
    // 打开wav文件
    NSError *error;
    [[NSFileManager defaultManager]createFileAtPath:wavfilename contents:nil attributes:nil];
    NSFileHandle *wavHandle = [NSFileHandle fileHandleForWritingToURL:[NSURL fileURLWithPath:wavfilename]  error:&error];
    if (error) {
        NSLog(@"wav文件创建失败：%@", error.description);
        [pcmhandle closeFile];
        return;
    }
    // 写入头部
    NSData *headerData = [NSData dataWithBytes:(void *)(header) length:sizeof(WavHeader)];
    [wavHandle writeData:headerData];
    
    // 写入PCM数据
    [pcmhandle seekToFileOffset:0];
    NSData *buf = [pcmhandle readDataOfLength:1024];
    NSInteger size = buf.length;
    while (size > 0) {
        if (buf) {
            [wavHandle writeData:buf];
            [wavHandle seekToEndOfFile];
        }
        buf = [pcmhandle readDataOfLength:1024];
        size = buf.length;
    }
    // 关闭文件
    [pcmhandle closeFile];
    [wavHandle closeFile];
}
@end
