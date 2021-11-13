//
//  DiskCache.swift
//  Simulator
//
//  Created by lieon on 2021/11/13.
//

import Foundation

class DiskCache: ImageCacheProtol {
    fileprivate var fileManager: FileManager {
        return FileManager.default
    }
    
    func getImageData(_ key: String) -> Data? {
        let path = pathFor(key)
        if fileManager.fileExists(atPath: path) {
            return try? Data(contentsOf: .init(fileURLWithPath: path))
        }
        return nil
    }
    
    func clear(_ key: String)  -> Bool{
        let path = pathFor(key)
        if fileManager.fileExists(atPath: path) {
            try? fileManager.removeItem(at: .init(fileURLWithPath: path))
            return true
        }
        return false
    }
    
    func clearAll() -> Bool{
        do {
            try fileManager.removeItem(at: .init(fileURLWithPath: DownLoaderFileManager.shared.chacheFolderAbsPath))
            return true
        } catch {
            return false
        }
    }
    
    func add(_ key: String, data: StorageData)  -> Bool {
        let path = DownLoaderFileManager.shared.createAbsFilePath(key)
        do {
            debugPrint(path)
            try data.data.write(to: .init(fileURLWithPath: path), options: .atomic)
            return true
        } catch {
            return false
        }
    }
    
    private func pathFor(_ key: String) -> String {
        let path = DownLoaderFileManager.shared.chacheFolderAbsPath + "/" + key
        return path
    }
}
