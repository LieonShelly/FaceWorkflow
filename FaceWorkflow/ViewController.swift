//
//  ViewController.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    fileprivate lazy var wavRecordBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("录制为wav", for: .normal)
        btn.setTitle("停止", for: .selected)
        btn.addTarget(self, action: #selector(wavBtnAction(_:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var playBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("播放", for: .normal)
        btn.setTitle("停止", for: .selected)
        btn.addTarget(self, action: #selector(playBtnAction(_:)), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var wavRecorder: RecordWAV = {
        let wavRecorder = RecordWAV()
        return wavRecorder
    }()
    fileprivate lazy var player: WavPlayer = {
        let player = WavPlayer()
        return player
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(wavRecordBtn)
        wavRecordBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        view.addSubview(playBtn)
        playBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(wavRecordBtn.snp.bottom).offset(10)
        }
    }

    @objc
    fileprivate func wavBtnAction(_ btn: UIButton) {
        if btn.isSelected {
            wavRecorder.stopRecord()
        } else {
            wavRecorder.record()
        }
        btn.isSelected = !btn.isSelected
    }
    
    @objc
    fileprivate func playBtnAction(_ btn: UIButton) {
        if btn.isSelected {
            player.stop()
        } else {
            
            player.play(withFile: wavRecorder.filename())
        }
        btn.isSelected = !btn.isSelected
    }

}

