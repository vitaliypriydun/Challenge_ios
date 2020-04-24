//
//  AppRouter.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

protocol AppRoutable {
    
    func startApplication()
}

class AppRouter {

    private weak var window: UIWindow?
    
    init(with window: UIWindow?) {
        self.window = window
    }
}

// MARK: - AppDelegateRoutable
    
extension AppRouter: AppRoutable {
    
    func startApplication() {
        guard let window = window else { return }
        window.makeKeyAndVisible()
        window.rootViewController = ModulesFactory.shared.makeHomeViewController().interface
        UIView.transition(with: window,
                          duration: 0.4,
                          options: [.transitionCrossDissolve, .curveEaseInOut],
                          animations: { },
                          completion: nil)
    }
}
