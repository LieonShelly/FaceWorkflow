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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playBtnAction(_ sender: Any) {
        let filename = Bundle.main.path(forResource: "test_video.MP4", ofType: nil)!
        service.setFilename(filename)
        service.play()
    }

}
