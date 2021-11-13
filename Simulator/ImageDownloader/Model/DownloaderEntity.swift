//
//  DownloaderEntity.swift
//  Simulator
//
//  Created by lieon on 2021/11/13.
//

import Foundation


class DownLoaderFileManager {
    static let shared: DownLoaderFileManager = .init()
    var homeDir: String {
        guard let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .allDomainsMask, true).first else {
            return ""
        }
        return library
    }
    
    var imageFolder: String  {
        let folderName = "/" + "com.ms.imagedownloader"
        return folderName
    }
    
    var chacheFolderAbsPath: String {
        return homeDir +  imageFolder
    }
    
    func createAbsFilePath(_ url: String) -> String {
        let cacheFolder = homeDir + imageFolder
        if !FileManager.default.fileExists(atPath: cacheFolder) {
            try? FileManager.default.createDirectory(atPath: cacheFolder, withIntermediateDirectories: true, attributes: nil)
        }
        return cacheFolder + "/" + imageName(url)
    }
    
    func imageName(_ url: String) -> String {
        let key = url.ms.md5
        return key
    }
    
    private init() {}
}

class DownloadImage {
    var name: String {
        return DownLoaderFileManager.shared.imageName(urlStr)
    }
    var urlStr: String
    var data: Data
    
    init(urlStr: String) {
        self.urlStr = urlStr
        data = Data()
    }
    
    func cacheKey(_ isMemory: Bool) -> String {
        return isMemory ? name : urlStr
    }
}

struct DownloadError: Error {
    var message: String
}
