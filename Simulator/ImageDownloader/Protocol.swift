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

private var taskIdentifierKey: String?
extension MSWrapper where Base == UIImageView {
    
    func setImage(_ url: URL) {
        var strongSelf = self
        strongSelf.taskIdentifier = UUID().uuidString
    }
    
    // MARK: Properties
    private(set) var taskIdentifier: String? {
        get {
            let id = objc_getAssociatedObject(base, &taskIdentifierKey) as? String
            return id
        }
        set {
            let box = newValue
            objc_setAssociatedObject(base, &taskIdentifierKey, box, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}



