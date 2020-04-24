//
//  AccessoryViewFactory.swift
//  TestTask42
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

typealias DoneHandler = (String?) -> Void

class InputViewFactory {

    static func makeDatePickerView() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.minimumDate = Date().addingTimeInterval(60)
        datePicker.backgroundColor = Asset.Colors.white.color
        return datePicker
    }

    static func makeDoneAccessoryView(target: AnyObject?, doneHandler: Selector?, cancelHandler: Selector?) -> UIToolbar {
        let font = UIFont(name: "avenir-medium", size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: .toolbarHeight))
        toolbar.barStyle = .default
        toolbar.backgroundColor = Asset.Colors.white.color
        toolbar.barTintColor = Asset.Colors.white.color
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        doneButton.tintColor = Asset.Colors.blue.color
        doneButton.target = target
        doneButton.action = doneHandler
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: Asset.Colors.blue.color]
        doneButton.setTitleTextAttributes(attributes, for: .normal)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        cancelButton.tintColor = Asset.Colors.blue.color
        cancelButton.target = target
        cancelButton.action = cancelHandler
        cancelButton.setTitleTextAttributes(attributes, for: .normal)
        
        let label = UILabel(frame: .zero)
        label.font = font
        label.text = Localization.Home.alarm
        let labelItem = UIBarButtonItem(customView: label)
        
        toolbar.setItems([cancelButton, flexibleSpace, labelItem, flexibleSpace, doneButton], animated: true)
        return toolbar
    }
}

// MARK: - Private

fileprivate extension CGFloat {

    static var toolbarHeight: CGFloat { return 44.0 }
}
