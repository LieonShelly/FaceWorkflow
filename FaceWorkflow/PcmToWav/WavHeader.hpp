//
//  WavHeader.hpp
//  FaceWorkflow
//
//  Created by lieon on 2021/6/22.
//

#ifndef WavHeader_hpp
#define WavHeader_hpp
#include <stdint.h>
#include <stdio.h>
#define AUDION_FORMAT_FLOAT 3

// WAV文件头(44字节)
struct WavHeader {
    // 整个riff
    // RIFF chunk的id
    uint8_t riffChunkId[4] = {'R', 'I', 'F', 'F'};
    // RiFF chunk的data的大小，即文件总长度减去8字节（riffChunkId[4] + 自身长度）
    uint32_t riffChunkSize;
    // 格式
    uint8_t format[4] = {'W', 'A', 'V', 'E'};
    // fmt sub-chunk
    uint8_t fmtChunkID[4] = {'f', 'm', 't', ' '};
    //fmt chunk的大小：存储PCM数据时，是16
    uint32_t fmtChunkDataSize = 16;
    // 音频编码， 1表示PCM， 3表示Floating Point
    uint16_t audioFormat = 1;// AUDION_FORMAT_FLOAT;
    // 声道数
    uint16_t numChannels;
    // 采样率
    uint32_t sampleRate;
    // 字节率 = sampleRate * blockAlign
    uint32_t byteRate;
    // 一个样本的字节数 = bitPerSample * numChannels >> 3
    uint16_t blockAlign;
    // 位深度，单声道下的一个样本的大小（单位：位）
    uint16_t bitPerSample;
    // data sub-chunk
    uint8_t dataChunId[4] = {'d', 'a', 't', 'a'};
    // data chunk的data大小: 音频数据的总长度，即文件总长度减去文件头的长度（一般是44）
    uint32_t dataChunkSize;
};


#endif /* WavHeader_hpp */
