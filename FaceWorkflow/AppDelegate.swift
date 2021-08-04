//
//  AppDelegate.swift
//  FaceWorkflow
//
//  Created by lieon on 2021/1/28.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
        TestTree.test()
        return true
    }
}

// 直接派发
func all() { }

class Person {
    final var age: Int {
        return 10
    }

    func eat() {
        
    }
    func commonMethod() {
        
    }
    
    /// private修饰：直接派发
    private func jump() { }
    
    static func staticMethod() {}
    
    final func finalMethod() { }
}

extension Person {
    func extensionMethod() { }
}

struct Model {
    
    func modelFunc() { }
}

final class Student: Person {
    
    override func eat() {
        
    }
    
    func run() {}
}

class Graduates: Person {
    
    func study() {
        
    }
}

class Animal {
    
   dynamic func run() {
        
    }
}

/// 协议采用的函数表派发的方式
protocol Eateable {
    func swite()
}

class Apple: Eateable {
    
    func swite() {
        
    }
}

class CustomView: UIView {
    /// static修饰：直接派发
    static func staticMehod() {}
    /// private: 直接派发
    private func privateMethod() {}
    /// final修饰：直接派发
    final func finalMethod() {}
    /// 直接派发
    static func staticMethod() {}
    /// 普通的实例方法 函数表派发
    func commonMethod() {}
    /// @objc修饰 函数表派发
    @objc func method1() {}
    /// dynamic修饰： 消息派发
    @objc dynamic
    func method2() {}
    /// 重写了OC的方法： 消息派发
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class Test {
    
    func handle() {
        let person = Person()
        /// 全局函数直接派发
        all()
        /// 引用的类型的实例方法： 函数表派发
        person.eat()
        person.commonMethod()
        let graduate = Graduates()
        graduate.study()
        
        ///  final修饰：直接派发
        person.finalMethod()
        /// static方法 直接派发
        Person.staticMethod()
        /// extension中没有被@objc修饰：直接派发
        person.extensionMethod()
        /// student final类型;所有方法的均为直接派发
        /// final 关键字可以用在 class，func 或者 var 前面进行修饰，表示不允许对该内容进行继承或者重写操作
        let student = Student()
        student.eat()
        student.run()
        /// 值类型：直接派发
        let data = Model()
        data.modelFunc()
    }
}
