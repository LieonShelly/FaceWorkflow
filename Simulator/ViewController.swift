//
//  ViewController.swift
//  Simulator
//
//  Created by lieon on 2021/9/15.
//

import UIKit

class ViewController: UIViewController {
    
    var imageDownloader: MSImageDownloader!
    var memCache: MemoryCache = .init()
    var diskCache: DiskCache = .init()
    let url = URL.init(string: "https://static.runoob.com/images/demo/demo1.jpg")!
    var testView: TestView? = TestView()
    let pareView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        pareView.backgroundColor = .yellow
        let btn = UIControl()// UIButton()
        btn.backgroundColor = .blue
        pareView.addSubview(btn)
        view.addSubview(pareView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(parentAction))
//        pareView.addGestureRecognizer(tap)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(parentAction1))
        view.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(parentAction2))
//        btn.addGestureRecognizer(tap2)
        
      
        let imageView = UIImageView()
        imageView.ms.setImage(url)
        
        imageDownloader = MSImageDownloader(url)
        imageDownloader.start()
        imageDownloader.resultCallback = {[weak self]result in
            guard let weakSelf = self else {
                return
            }
            switch result {
            case .success(let image):
                let storeage = StorageData(image.data)
                _ = weakSelf.memCache.add(image.cacheKey(true), data: storeage)
                _ = weakSelf.diskCache.add(image.cacheKey(false), data: storeage)
            case .failure(let error):
                debugPrint(error.message)
            }
        }
        imageDownloader.progressCallback = { progress in
            debugPrint("progressCallback: \(progress)")
        }
        // 通过layoutanchor创建约束
        pareView.translatesAutoresizingMaskIntoConstraints = false;
        let top = pareView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)
        let left = pareView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50)
        let height = pareView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        let width = pareView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        // 将约束添加view上才生效
        view.addConstraints([top, left, height, width])
        
        //  动态计算、改变视图尺寸，需要将translatesAutoresizingMaskIntoConstraints设置为false
        btn.translatesAutoresizingMaskIntoConstraints = false
        pareView.addConstraints([
            btn.topAnchor.constraint(equalTo: pareView.topAnchor, constant: 0),
            btn.leftAnchor.constraint(equalTo: pareView.leftAnchor),
            btn.heightAnchor.constraint(equalToConstant: 50),
            btn.widthAnchor.constraint(equalToConstant: 50)
        ])
        
//        // 添加约束的另一种方式
//        NSLayoutConstraint.activate([
//            btn.topAnchor.constraint(equalTo: pareView.topAnchor, constant: 0),
//            btn.leftAnchor.constraint(equalTo: pareView.leftAnchor),
//            btn.heightAnchor.constraint(equalToConstant: 50),
//            btn.widthAnchor.constraint(equalToConstant: 50)
//        ])

        pareView.addSubview(testView!)
        testView!.backgroundColor = .purple
        testView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testView!.topAnchor.constraint(equalTo: pareView.topAnchor, constant: 100),
            testView!.leftAnchor.constraint(equalTo: pareView.leftAnchor),
            testView!.heightAnchor.constraint(equalToConstant: 50),
            testView!.widthAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    
    @objc
    fileprivate func parentAction2() {
        debugPrint("btn-gesture-tap")
    }
    
    @objc
    fileprivate func parentAction1() {
        debugPrint("view-tap")
        testView!.removeFromSuperview()
        testView = nil
    }
    
    @objc
    fileprivate func parentAction() {
        debugPrint("parentAction")
    }
    @objc
    fileprivate func btnAction() {
        debugPrint("btnAction")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
    }
    
}

class TestView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        addSubview(btn)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        
    }
    override func didMoveToWindow() {
        
    }
    override func willMove(toSuperview newSuperview: UIView?) {
    
    }
    override func didMoveToSuperview() {
        
    }
    override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        
    }
    
    deinit {
        debugPrint("TestView-deinit")
    }
}

class TestBtn: UIView {
    
}



class TestCurring {
    func addOne(_ num: Int) -> Int {
        return num + 1
    }
    
    func add(_ num1: Int) -> ((Int) -> Int) {
        return { num1 + $0}
    }
    
    // add1(10, 20, 30) = add1(30)(20)(10)
    func add1(_ num3: Int) -> ((Int) -> ((Int) -> Int)) {
        // num1 = 10
        // num2 = 20
        return { num2 in
            // num3 = 30
            return { num1 in
                return num3 + num2 + num1
            }
        }
    }

}


/**
 写一个通用函数将两个参数的函数转换为柯里化
 add(1)(2)
 */
func add(_ v1: Int, _ v2: Int) -> Int {
    return v1 + v2
}

func sub(_ v1: Int, _ v2: Int) -> Int {
    return v1 - v2
}

func addC(_ v1: Int) -> (Int) -> Int {
    return { v2 in
        return v2 + v1
    }
}

prefix func ~<A, B, C>(_ fn: @escaping (A, B) -> C) -> (B) -> (A) -> C {
    // v3: B
    return { v3 in
        // v2: C
        return { v2 in
            return fn(v2, v3)
        }
    }
}


infix operator >>> : AdditionPrecedence
func >>><A, B, C>(_ f1: @escaping (A) -> B,
                  _ f2: @escaping (B) -> C) -> (A) -> C {
    return { a in
        f2(f1(a))
    }
}


class Test {
    func test() {
        addC(1)(2)
        let num = 2
        let fn = (~add)(3)
        let result = fn(num)
        // 3 + 2 2
        let result1 = (~add)(3) >>> (~sub)(4)
        print(result1(num))
        
        let res1 = [[[0, 0]],[[0, 0]],[[0, 0]]].flatMap({ $0})
        
    }
}

extension Array {
    func mapArray<T>(_ fn: (Element) -> T) -> Array<T> {
        var newArray: [T] = []
        for element in self {
            newArray.append(fn(element))
        }
        return newArray
    }

    
    
}

class SquareIterator: IteratorProtocol {
    typealias Element = Int
    var state = (curr: 0, next: 1)
    
    func next() -> Int? {
        let curr = state.curr
        let next = state.next
        state = (curr: next, next: next + 1)
        if curr == 0 {
            return 1
        }
        return curr * curr
    }
    
}

class CustomSequence: Sequence {
    typealias Element = Int
    
    func makeIterator() -> SquareIterator {
        return SquareIterator()
    }
}
