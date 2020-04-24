//
//  AlertFactory.swift
//  TestTask42
//
//  Created by Vitalii on 24.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

typealias SleepTimeHandler = (SleepTime?) -> Void

class AlertFactory {

    static func makeSleepTimeActionSheet(handler: @escaping SleepTimeHandler) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: Localization.Home.sleepTimer, preferredStyle: .actionSheet)
        SleepTime.allCases.forEach({ time in
            alert.addAction(.init(title: time.text, style: .default, handler: { _ in
                handler(time)
                alert.dismiss(animated: true, completion: nil)
            }))
        })
        alert.addAction(.init(title: Localization.Buttons.cancel, style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        return alert
    }
}
