//
//  MemoryCache.swift
//  Simulator
//
//  Created by lieon on 2021/11/13.
//  内存缓存

import Foundation

// 优化：增加自动内存清理逻辑
class MemoryCache: ImageCacheProtol {
    var cachePool: NSCache<NSString, StorageData> = {
        let cache: NSCache<NSString, StorageData> = .init()
        cache.totalCostLimit = 10 * 1024 * 1024 // 10M
        return cache
    }()
    
    func getImageData(_ key: String) -> Data? {
        guard let storage = cachePool.object(forKey: key as NSString) else {
            return nil
        }
        return storage.data
    }
    
    func clear(_ key: String) -> Bool {
        cachePool.removeObject(forKey: key as NSString)
        return true
    }
    
    func clearAll() -> Bool {
        cachePool.removeAllObjects()
        return true
    }
    
    func add(_ key: String, data: StorageData) -> Bool {
        cachePool.setObject(data, forKey: key as NSString)
        return true
    }
    
}
