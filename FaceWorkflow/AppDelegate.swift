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
        window?.rootViewController = UINavigationController(rootViewController: RunLoopObserverViewController())
        window?.makeKeyAndVisible()
        return true
    }

}

