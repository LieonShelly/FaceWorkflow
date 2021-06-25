//
//  FFMpegs.cpp
//  FaceWorkflow
//
//  Created by lieon on 2021/6/22.
//

#include "FFMpegs1.hpp"
#include <fstream>
#include <iostream>

using namespace std;

void FFMpegs1::pcm2wav(WavHeader &header, const char *pcmFilename, const char *wavfilename) {
    // 一个样本的字节数
    header.blockAlign = header.bitPerSample * header.numChannels >> 3;
    // 字节数
    header.byteRate = header.sampleRate * header.blockAlign;
    // 打开PCM文件
    ifstream pcmfile;
    pcmfile.open(pcmFilename);
    if (!pcmfile) {
        cout << "PCM文件打开失败" << endl;
    }
    pcmfile.seekg(ios::end);
    header.dataChunkSize = (uint32_t)pcmfile.tellg();
    header.riffChunkSize = header.dataChunkSize + sizeof(WavHeader) - sizeof(header.riffChunkId) - sizeof(header.riffChunkSize);
}
