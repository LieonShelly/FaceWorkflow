//
//  MediaComposition.swift
//  Simulator
//
//  Created by lieon on 2021/11/25.
//

import AVFoundation
import UIKit
import AssetsLibrary

class BasicComposition {
    func test() {
        let url = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        let asset = AVURLAsset(url: url)
        let goldenGateAsset = AVURLAsset(url: url)
        let teaGardenAsset = AVURLAsset(url: url)
        let soundtrackAsset = AVURLAsset(url: url)
        
        asset.loadValuesAsynchronously(forKeys: ["tracks", "duration", "commonMetadata"]) {
            
        }
        // 添加轨道到composition
        let composition = AVMutableComposition()
        let videonTrakId: Int32 = 1
        let audioTrackId: Int32 = 2
        let videoTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: videonTrakId)
        let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: audioTrackId)
        
        var cursortime: CMTime = .zero
        let videoDuration = CMTime(value: 5, timescale: 1)
        let videoTimeRange = CMTimeRangeMake(start: .zero, duration: videoDuration)
        if let assetTrack = goldenGateAsset.tracks(withMediaType: .video).first {
            // 拼结第一段素材
            try? videoTrack?.insertTimeRange(videoTimeRange, of: assetTrack, at: cursortime)
        }
        // 改变指针位置
        cursortime = CMTimeAdd(cursortime, videoDuration)
        if let assetTrack = teaGardenAsset.tracks(withMediaType: .video).first {
            // 拼结第二段素材
            try? videoTrack?.insertTimeRange(videoTimeRange, of: assetTrack, at: cursortime)
        }
        cursortime = .zero
        let audioDuration = composition.duration
        let audioTimeRange = CMTimeRangeMake(start: .zero, duration: audioDuration)
        if let assetTrack = soundtrackAsset.tracks(withMediaType: .audio).first {
            try? audioTrack?.insertTimeRange(audioTimeRange, of: assetTrack, at: cursortime)
        }
    }
    
    func testComposition() {
        let timeline = THTimeline()
        timeline.voiceOvers = [THMediaItem()]
        timeline.videos = [THMediaItem()]
        timeline.music = [THMediaItem()]
        let bulider = THBasicComposition(timeline)
        let composition = bulider.buildCompostion()
        let exporter = THCompositionExporter(composition)
        exporter.beginExport()
    }
    
    func testAudioMix() {
        let composition = AVMutableComposition()
        let track = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: .zero)
        let twoSeoncds = CMTime(value: 2, timescale: 1)
        let fourSeoncds = CMTime(value: 4, timescale: 1)
        let sevenSeoncds = CMTime(value: 7, timescale: 1)
        let parameters = AVMutableAudioMixInputParameters(track: track)
        parameters.setVolume(0.5, at: .zero)
        
        let range = CMTimeRange(start: twoSeoncds, end: sevenSeoncds)
        parameters.setVolumeRamp(fromStartVolume: 0.6, toEndVolume: 0.8, timeRange: range)
        parameters.setVolume(0.3, at: sevenSeoncds)
        
        let audioMix = AVMutableAudioMix()
        audioMix.inputParameters = [parameters]
    }
}

class THTimeline {
    var videos: [THMediaItem] = []
    var voiceOvers: [THMediaItem] = []
    var music: [THMediaItem] = []
}

class THMediaItem {
    var startTimeInTimeline: CMTime = .zero
    var asset: AVAsset!
    var timeRange: CMTimeRange!
}

protocol THComposition {
    func makePlayable() -> AVPlayerItem
    func makeExportable() -> AVAssetExportSession
}

class THBasicCompsition: THComposition {
    var composition: AVComposition
    
    init(_ composition: AVComposition) {
        self.composition = composition
    }
    
    func makePlayable() -> AVPlayerItem {
        AVPlayerItem(asset: self.composition.copy() as! AVAsset)
    }
    
    func makeExportable() -> AVAssetExportSession {
        return AVAssetExportSession(asset: self.composition.copy() as! AVAsset, presetName: AVAssetExportPresetHighestQuality)!
    }
}


protocol THCompositionBuilder {
    func buildCompostion() -> THComposition
}

class THBasicComposition: THCompositionBuilder {
    var compostion: AVMutableComposition!
    var timelime: THTimeline
    
    init(_ timeline: THTimeline) {
        self.timelime = timeline
    }
    
    func buildCompostion() -> THComposition {
        compostion = AVMutableComposition.init()
        addCompositionTrack(with: .video, mediaItems: self.timelime.videos)
        addCompositionTrack(with: .audio, mediaItems: self.timelime.voiceOvers)
        addCompositionTrack(with: .audio, mediaItems: self.timelime.music)
        return THBasicCompsition(compostion)
    }
    
    private func addCompositionTrack(with mediaType: AVMediaType, mediaItems: [THMediaItem]) {
        let trackId: CMPersistentTrackID = -1
        let compositionTrack = self.compostion .addMutableTrack(withMediaType: mediaType, preferredTrackID: trackId)
        var cursorTime: CMTime = .zero
        for mediaItem in mediaItems {
            cursorTime = mediaItem.startTimeInTimeline
            if let assettrack = mediaItem.asset .tracks(withMediaType: mediaType).first {
                try? compositionTrack?.insertTimeRange(mediaItem.timeRange, of: assettrack, at: cursorTime)
                cursorTime = CMTimeAdd(cursorTime, mediaItem.timeRange.duration)
            }
        }
    }
}

class THCompositionExporter {
    var exporting: Bool = false
    var progress: CGFloat = 0
    var composition: THComposition
    fileprivate var exportSession: AVAssetExportSession!
    
    init(_ composition: THComposition) {
        self.composition = composition
    }
    
    func beginExport() {
        exportSession = self.composition.makeExportable()
        exportSession.outputURL = exportURL()
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously {
            DispatchQueue.main.async {
                let status = self.exportSession.status
                if status == .completed {
                    self.writeExportedVideoToAssetLibray()
                } else {
                    debugPrint("Export Failed")
                }
            }
        }
        self.exporting = true
        monitorExportProgress()
    }
    
    func exportURL() -> URL {
        var count = 0
        var filePath: String = ""
        repeat {
            filePath = NSTemporaryDirectory()
            let fileName = "Masterpiece-" + "\(count)" + ".mp4"
            filePath = filePath + "/" + fileName
            count += 1
        } while (FileManager.default.fileExists(atPath: filePath))
        return URL(fileURLWithPath: filePath)
    }
    
    func monitorExportProgress() {
        let delayInSeconds = 0.1
        let time = DispatchTime.now() + delayInSeconds
        DispatchQueue.main.asyncAfter(deadline: time) {
            while self.exportSession.status == .exporting  {
                self.exporting = true
                self.progress = CGFloat(self.exportSession.progress)
                self.monitorExportProgress()
            }
        }
    }
    
    func writeExportedVideoToAssetLibray() {
        let exportURL = exportSession.outputURL
        let library = ALAssetsLibrary()
        if library.videoAtPathIs(compatibleWithSavedPhotosAlbum: exportURL) {
            library.writeVideoAtPath(toSavedPhotosAlbum: exportURL) { assetURL, error in
                if error != nil  {
                    debugPrint("Unable to write Photos library")
                    return
                }
                try? FileManager.default.removeItem(at: exportURL!)
            }
        } else {
            debugPrint("video could not be exported to the assets libray")
        }
    }
}

class THAudioMixComposition {
    
}
