//
//  ViewController.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

import UIKit
import SnapKit


class TestThread: Thread {
    
    override init() {
        super.init()
    
    }
    
    deinit {
        debugPrint("TestThread - deinit")
    }
}

class ViewController: UIViewController {
    fileprivate lazy var videoRecord: RecordVideo = {
        let videoRecord = RecordVideo()
        return videoRecord
    }()
    fileprivate lazy var wavRecordBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("录制", for: .normal)
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
    fileprivate lazy var testView: TestView = {
        let testView = TestView()
        return testView
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
            videoRecord.stop()
        } else {
            videoRecord.recordVideo()
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

class TestView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        debugPrint("TestView-draw:\(rect)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        debugPrint("layoutSubviews")
        let origin = Orginator()
        origin.state = "1"
        /// 开始备忘
        let mento = origin.createMemento()
        let care = Caretaker()
        care.setMemento(mento)
        
        origin.state = "2"
        origin.restoreMemento(care.mennto!)
        
        debugPrint("state:\(origin.state)")
    }
}


// 备忘录模式

class Orginator {
    var state: String = ""
    
    func createMemento() -> Memento {
        return Memento(state)
    }
    
    func restoreMemento(_ m: Memento) {
    }
}


class Memento {
   private var state: String
    
    init(_ state: String) {
        self.state = state
    }
}

class Caretaker {
   fileprivate(set) var mennto: Memento?
    
    func setMemento(_ mento: Memento) {
        self.mennto = mento
    }
    
}
