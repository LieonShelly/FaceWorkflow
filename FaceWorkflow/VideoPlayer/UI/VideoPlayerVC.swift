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
    }
    
    @IBAction func playBtnAction(_ sender: Any) {
        let filename = Bundle.main.path(forResource: "test_video.MP4", ofType: nil)!
        service.setFilename(filename)
        service.play()
    }

}
