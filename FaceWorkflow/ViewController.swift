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
        btn.addTarget(self, action: #selector(wavBtnAction), for: .touchUpInside)
        return btn
    }()
    fileprivate lazy var wavRecorder: RecordWAV = {
        let wavRecorder = RecordWAV()
        return wavRecorder
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(wavRecordBtn)
        wavRecordBtn.snp.makeConstraints {
            $0.center.equalToSuperview()
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

}

