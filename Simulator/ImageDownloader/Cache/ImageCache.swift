//
//  ImageCache.swift
//  Simulator
//
//  Created by lieon on 2021/11/13.
//

import Foundation

/// 缓存相关的接口
protocol ImageCacheProtol {
    func cached(_ key: String) -> Bool
    func getImageDataAsync(_ key: String, success: @escaping ((Data?) -> Void))
    func getImageData(_ key: String) -> Data?
    func clear(_ key: String) -> Bool
    func clearAll() -> Bool
    func add(_ key: String, data: StorageData) -> Bool
}

extension ImageCacheProtol {
    func pathFor(_ key: String) -> String {
        let path = DownLoaderFileManager.shared.chacheFolderAbsPath + "/" + key
        return path
    }
}

class ImageCache: ImageCacheProtol {
    func cached(_ key: String) -> Bool {
        return memoryCache.cached(key) || diskCache.cached(key)
    }
    
    func getImageDataAsync(_ key: String, success: @escaping ((Data?) -> Void)) {
        let semaphore = DispatchSemaphore(value: 0)
        let lock = NSLock()
        DispatchQueue.global().async {
            var inMemory = false
            self.memoryCache.getImageDataAsync(key, success: { data in
                lock.lock()
                inMemory = data != nil
                lock.unlock()
                success(data)
                semaphore.signal()
            })
            semaphore.wait()
            if inMemory {
                return
            }
            self.diskCache.getImageDataAsync(key, success: { data in
                success(data)
            })
        }
    }
    
    static let `default`: ImageCache = ImageCache()
    private var memoryCache: MemoryCache = MemoryCache.default
    private var diskCache: DiskCache = DiskCache.default
    private var lock: NSLock = .init()
    
    func getImageData(_ key: String) -> Data? {
        if let memStorage = memoryCache.getImageData(key) {
            return memStorage
        }
        return diskCache.getImageData(key)
    }
    
    func clear(_ key: String) -> Bool {
        return memoryCache.clear(key) && diskCache.clear(key)
    }
    
    func clearAll() -> Bool {
        return memoryCache.clearAll() && diskCache.clearAll()
    }
    
    func add(_ key: String, data: StorageData) -> Bool {
        let inMemory = memoryCache.cached(key)
        if !inMemory {
            DispatchQueue.global().async {
                self.lock.lock()
                _ = self.memoryCache.add(key, data: data)
                self.lock.unlock()
            }
        }
        let inDisk = diskCache.cached(key)
        if !inDisk {
            DispatchQueue.global().async {
                self.lock.lock()
                _ = self.diskCache.add(key, data: data)
                self.lock.unlock()
            }
        }
        return true
    }
}
