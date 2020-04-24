//
//  Module.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import Foundation

class Module<PresenterType, InterfaceType> {
    
    private(set) var presenter: PresenterType
    private(set) var interface: InterfaceType
    
    init(presenter: PresenterType, interface: InterfaceType) {
        self.presenter = presenter
        self.interface = interface
    }
}
