//
//  HomeRouter.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

protocol HomeRouterProtocol {
    
    func showSleepTimePicker(handler: @escaping SleepTimeHandler)
}

class HomeRouter: NSObject {
    
    internal weak var viewController: UIViewController?
    
    // MARK: - Lifecycle
    
    init(with viewController: UIViewController?) {
        self.viewController = viewController
    }
}

// MARK: - HomeRouterProtocol

extension HomeRouter: HomeRouterProtocol {
    
    func showSleepTimePicker(handler: @escaping SleepTimeHandler) {
        let alert = AlertFactory.makeSleepTimeActionSheet(handler: handler)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
