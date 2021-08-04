//
//  VideoPlayerVC.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/7/30.
//

import UIKit

class VideoPlayerVC: UIViewController {
    @IBOutlet weak var playbtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playerVIew: UIView!
    fileprivate lazy var service: VideoService = {
        let service = VideoService()
        return service
    }()
    fileprivate lazy var contenView: PlayerView = {
        let playerView = PlayerView()
        return playerView
    }()
    @IBOutlet weak var progresSlider: UISlider!
    
    @IBOutlet weak var volumnSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
//        playerVIew.addSubview(contenView)
//        contenView.snp.makeConstraints {
//            $0.edges.equalTo(0)
//        }
//        service.delegate = self
//        volumnSlider.maximumValue = 1
//        volumnSlider.minimumValue = 0
//        volumnSlider.setValue(1, animated: true)
//        
//        progresSlider.maximumValue = 1
//        progresSlider.minimumValue = 0
//        progresSlider.setValue(1, animated: true)
        TestTree.test()
    }
    
    @IBAction func playBtnAction(_ sender: UIButton) {
        if sender.isSelected {
            service.pause()
        } else {
            let filename = Bundle.main.path(forResource: "test_video.MP4", ofType: nil)!
            service.setFilename(filename)
            service.play()
        }
        sender.isSelected  = !sender.isSelected
    }
    
    @IBAction func stopBtnAction(_ sender: Any) {
        service.stop()
        contenView.setPlayerContents(nil)
    }
    
    @IBAction func muteBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        service.setMute(sender.isSelected)
    }
    
    @IBAction func volumnSliderAction(_ sender: UISlider) {
        service.setVolumn(sender.value)
    }
    
    @IBAction func progressBtnAction(_ sender: UISlider) {
        service.setTime(sender.value)
    }
}

extension VideoPlayerVC: PlayerServiceDelegate {
    
    func playerDidDecodeVideoFrame(_ imge: CGImage?, imgSize size: CGSize) {
        DispatchQueue.main.async {
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
    
    func playerTimeDidChanged(_ time: Double) {
        print("playerTimeDidChanged:\(time)")
        let duration = service.getDuration()
        DispatchQueue.main.async {
            self.timeLabel.text = "\(time)" + "/" + "\(duration)"
            let progress = time / Double(duration) * 1.0
            self.progresSlider.setValue(Float(progress), animated: true)
        }
       
    }
    
    func playerStateDidChanged(_ state: PlayerState) {

    }
    
}
