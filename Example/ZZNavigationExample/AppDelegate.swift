//
//  AppDelegate.swift
//  ZZNavigationExample
//
//  Created by Ethan on 2022/10/12.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit
import SnapKit
import ZZNavigation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ZZNavigationController(rootViewController: HomeViewController())
        window?.makeKeyAndVisible()
        return true
    }

}
