//
//  StorageData.swift
//  Simulator
//
//  Created by lieon on 2021/11/13.
//

import Foundation

class StorageData: NSObject {
    var data: Data
    
    override init() {
        self.data = Data()
        super.init()
    }
    
    convenience init(_ data: Data) {
        self.init()
        self.data = data
    }
}
