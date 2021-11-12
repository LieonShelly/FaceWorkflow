//
//  Protocol.swift
//  Simulator
//
//  Created by lieon on 2021/11/12.
//

import Foundation
import UIKit


struct MSWrapper<Base> {
    var base: Base
}

protocol MSPrototol {
    
}

extension MSPrototol {
    var ms: MSWrapper<Self> {
        return MSWrapper.init(base: self)
    }
}

extension MSWrapper where Base == UIImageView {
    
    func setImage(_ url: URL) {

    }
}

