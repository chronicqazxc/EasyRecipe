//
//  AppDelegate.swift
//  EasyRecipeDemo
//
//  Created by Hsiao, Wayne on 2019/10/4.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import UIKit
import WHUIComponents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootCoordinate: Coordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController()
        rootCoordinate = MainCoordinator(navigationController: window?.rootViewController as! UINavigationController)
        rootCoordinate.start()
        window?.makeKeyAndVisible()
        
        return true
    }
}

