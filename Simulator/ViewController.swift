//
//  ViewController.swift
//  Simulator
//
//  Created by lieon on 2021/9/15.
//

import UIKit

class ViewController: UIViewController {
    
    var imageDownloader: MSImageDownloader!

    override func viewDidLoad() {
        super.viewDidLoad()
        let pareView = UIView()
        pareView.backgroundColor = .yellow
        pareView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let btn = UIButton()
        btn.frame = CGRect(x: 50, y: 100, width: 30, height: 30)
        btn.backgroundColor = .blue
        pareView.addSubview(btn)
        view.addSubview(pareView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(parentAction))
        pareView.addGestureRecognizer(tap)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        let url = URL.init(string: "https://static.runoob.com/images/demo/demo1.jpg")!
        let imageView = UIImageView()
        imageView.ms.setImage(url)
        
        imageDownloader = MSImageDownloader(url)
    }
    
    @objc
    fileprivate func parentAction() {
        debugPrint("parentAction")
    }
    @objc
    fileprivate func btnAction() {
        debugPrint("btnAction")
    }


}

