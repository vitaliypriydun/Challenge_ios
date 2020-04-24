//
//  AppDelegate.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private var router: AppRoutable?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        startApplication()
        return true
    }
    
    // MARK: - Private
    
    private func startApplication() {
        window = UIWindow(frame: UIScreen.main.bounds)
        router = AppRouter(with: window)
        router?.startApplication()
    }
}
