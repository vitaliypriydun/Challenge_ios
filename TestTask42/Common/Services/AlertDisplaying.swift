//
//  AlertDisplaying.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

protocol AlertDisplaying: class {
    
    func displayAlert(title: String)
}

extension AlertDisplaying where Self: UIViewController {
    
    func displayAlert(title: String) {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Localization.Buttons.ok, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
