//
//  ImageCache.swift
//  Simulator
//
//  Created by lieon on 2021/11/13.
//

import Foundation

/// 缓存相关的接口
protocol ImageCacheProtol {
    func getImageData(_ key: String) -> Data?
    func clear(_ key: String) -> Bool
    func clearAll() -> Bool
    func add(_ key: String, data: StorageData) -> Bool
}
