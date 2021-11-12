//
//  MSImageDownloader.swift
//  Simulator
//
//  Created by lieon on 2021/11/12.
//

import Foundation

class MSImageDownloader: NSObject {
    private(set) var url: URL
    private var dataTask: URLSessionDataTask!
    var totalLenth: Double = 0.0
    lazy var fileStram: OutputStream = {
        let filepath = self.createFilePath(self.url.absoluteString)
        let stream = OutputStream(toFileAtPath: filepath, append: true)
        return stream!
    }()
    
    init(_ url: URL) {
        self.url = url
        super.init()
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let seesionQueue = OperationQueue.init()
        let session = URLSession(configuration: config, delegate: self, delegateQueue: seesionQueue)
        dataTask = session.dataTask(with: request)
        dataTask.resume()
    }
    
}

extension MSImageDownloader {
    
    func createFilePath(_ url: String) -> String {
        guard let library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .allDomainsMask, true).first else {
            return ""
        }
        let cacheFolder = library + "/" + "com.ms.imagedownloader"
        if !FileManager.default.fileExists(atPath: cacheFolder) {
            try? FileManager.default.createDirectory(atPath: cacheFolder, withIntermediateDirectories: true, attributes: nil)
        }
        return cacheFolder + "/" + innerKey(url)
    }
    
    func innerKey(_ url: String) -> String {
        let key = url.ms.md5
        debugPrint(key)
        return key
    }
}

extension MSImageDownloader: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        fileStram.open()
        // 获取文件信息
        totalLenth = Double(response.expectedContentLength)
        debugPrint("MSImageDownloader-totalLenth:\(totalLenth)")
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        _ = data.withUnsafeBytes { pointer in
            fileStram.write(pointer, maxLength: data.count)
        }
        let downloadLen = Double(data.count)
        let progress = downloadLen / totalLenth
        debugPrint("MSImageDownloader-downloading-progress:\(progress)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        fileStram.close()
        if error != nil {
            
        } else {
            
        }
    }
}
