//
//  MSImageDownloader.swift
//  Simulator
//
//  Created by lieon on 2021/11/12.
//

import Foundation

class MSImageDownloader: NSObject {
    var resultCallback: ((Result<DownloadImage, DownloadError>) -> Void)?
    var progressCallback: ((Double) -> Void)?
    private(set) var url: URL
    private var dataTask: URLSessionDataTask!
    private(set) var totalLenth: Double = 0.0
    private var currentImage: DownloadImage!
    private var fileStram: OutputStream!
    
    init(_ url: URL) {
        self.url = url
        super.init()
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let seesionQueue = OperationQueue.init()
        let session = URLSession(configuration: config, delegate: self, delegateQueue: seesionQueue)
        dataTask = session.dataTask(with: request)
        let filepath = DownLoaderFileManager.shared.createAbsFilePath(url.absoluteString)
        fileStram = OutputStream(toFileAtPath: filepath, append: true)
        currentImage = DownloadImage(urlStr: url.absoluteString)
    }
    
    func start() {
        dataTask.resume()
    }
}

extension MSImageDownloader: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        fileStram.open()
        progressCallback?(0)
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
        progressCallback?(progress)
        debugPrint("MSImageDownloader-downloading-progress:\(progress)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        fileStram.close()
        if error != nil {
            let success = Result<DownloadImage, DownloadError>.failure(.init(message: "下载失败"))
            resultCallback?(success)
        } else {
            guard let image = self.currentImage else {
                return
            }
            let success = Result<DownloadImage, DownloadError>.success(image)
            progressCallback?(1.0)
            resultCallback?(success)
        }
    }
}
