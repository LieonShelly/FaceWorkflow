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
    
    init(_ url: URL) {
        self.url = url
        super.init()
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let seesionQueue = OperationQueue.init()
        let session = URLSession(configuration: config, delegate: self, delegateQueue: seesionQueue)
        dataTask = session.dataTask(with: request)
        currentImage = DownloadImage(urlStr: url.absoluteString)
    }
    
    func start() {
        dataTask.resume()
    }
}

extension MSImageDownloader: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        progressCallback?(0)
        totalLenth = Double(response.expectedContentLength)
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        currentImage.data.append(data)
        let downloadLen = Double(data.count)
        let progress = downloadLen / totalLenth
        progressCallback?(progress)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
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
