//
//  AppDelegate.swift
//  WXLC
//
//  Created by liangpengshuai on 21/11/2016.
//  Copyright © 2016 com.wxjr. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AVOSCloud.setApplicationId("FvxkWCzdIu8iPg0S35ML2zrQ-gzGzoHsz", clientKey: "tmMUWuF9q86ReOur6ClEzYNC")
        AVOSCloud.setAllLogsEnabled(true)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }


}

