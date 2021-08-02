//
//  PlayerView.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/8/2.
//

import UIKit

class PlayerView: UIView {
    fileprivate lazy var playLayer: CAShapeLayer = {
        let playLayer = CAShapeLayer()
        return playLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(playLayer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updatePlayerRect(_ rect: CGRect) {
        self.playLayer.frame = rect
    }
    
    func setPlayerContents(_ contents: CGImage?) {
        self.playLayer.contents = contents
    }
}
