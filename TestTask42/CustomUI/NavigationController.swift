//
//  NavigationController.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeAppearance()
    }

    // MARK: - Private
    
    private func customizeAppearance() {
        hidesBarsOnSwipe = false
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = Asset.Colors.white.color
        navigationBar.barTintColor = Asset.Colors.white.color
    }
}
