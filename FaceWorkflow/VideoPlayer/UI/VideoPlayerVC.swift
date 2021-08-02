//
//  VideoPlayerVC.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/7/30.
//

import UIKit

class VideoPlayerVC: UIViewController {
    @IBOutlet weak var playbtn: UIButton!
    @IBOutlet weak var playerVIew: UIView!
    fileprivate lazy var service: VideoService = {
        let service = VideoService()
        return service
    }()
    fileprivate lazy var contenView: PlayerView = {
        let playerView = PlayerView()
        return playerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerVIew.addSubview(contenView)
        contenView.snp.makeConstraints {
            $0.edges.equalTo(0)
        }
        service.delegate = self
    }
    
    @IBAction func playBtnAction(_ sender: Any) {
        let filename = Bundle.main.path(forResource: "test_video.MP4", ofType: nil)!
        service.setFilename(filename)
        service.play()
    }
    
}

extension VideoPlayerVC: PlayerServiceDelegate {
    
    func playerDidDecodeVideoFrame(_ imge: CGImage?, imgSize size: CGSize) {
        DispatchQueue.main.async {
//            self.service.releasePreFrame()
            let width = self.playerVIew.bounds.width
            let height = self.playerVIew.bounds.height
            
            var dx: CGFloat = 0
            var dy: CGFloat = 0
            var dw = size.width
            var dh = size.height
            // 计算目标尺寸
            if dw > width || dh > height {
                if dw * height > width * dh {
                    // 视频的宽高比 > 播放器的宽高比
                    dh = width * dh / dw
                    dw = width
                } else {
                    dw = height * dw / dh
                    dh = height
                }
            }
            dx = (width - dw) * 0.5
            dy = (height - dh) * 0.5
            let playerRect = CGRect(x: dx, y: dy, width: dw, height: dh)
            self.contenView.updatePlayerRect(playerRect)
            self.contenView.setPlayerContents(imge!)
        }
    }
}
