//
//  ModulesFactory.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

class ModulesFactory {

    // MARK: - Private
    
    private let servicesFactory = ServicesFactory()
    
    // MARK: - Singleton
        
    static let shared: ModulesFactory = ModulesFactory()
    private init() {}
    
    // MARK: - Public
    
    func makeHomeViewController() -> Module<HomeOutput, UIViewController> {
        let viewController = HomeViewController()
        let router = HomeRouter(with: viewController)
        let presenter = HomePresenter(withView: viewController,
                                      router: router,
                                      mediaPlayerService: servicesFactory.makeMediaPlayerService(),
                                      notificationService: servicesFactory.makeNotificationService())
        viewController.presenter = presenter
        return Module(presenter: presenter, interface: makeNavigationController(with: viewController))
    }
    
    // MARK: - Private
    private func makeNavigationController(with viewController: UIViewController) -> UINavigationController {
        let navigationController = NavigationController()
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "avenir-medium", size: 17) ?? UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: Asset.Colors.black.color]
        navigationController.navigationBar.tintColor = Asset.Colors.black.color
        navigationController.viewControllers = [viewController]
        return navigationController
    }
}
