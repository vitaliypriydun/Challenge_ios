//
//  HomeViewController.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var presenter: HomeOutput?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var actionButton: UIButton!
    @IBOutlet private weak var sleepTimerLabel: UILabel!
    @IBOutlet private weak var alarmLabel: UILabel!
    @IBOutlet private weak var sleepTimerValueLabel: UILabel!
    @IBOutlet private weak var alarmTextField: UITextField!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTexts()
        performInitialSetup()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction private func alarmAction(_ sender: Any) {
        presenter?.viewTriggeredAlarmAction()
    }
    
    @IBAction func sleepTimerAction(_ sender: Any) {
        presenter?.viewTriggeredSleepTimerAction()
    }
    
    @IBAction private func buttonAction(_ sender: Any) {
        presenter?.viewTriggeredButtonAction()
    }
    
    @objc private func textfieldDoneAction(_ sender: Any) {
        guard let datePicker = alarmTextField.inputView as? UIDatePicker else { return }
        presenter?.viewTriggeredDoneAction(date: datePicker.date)
    }
    
    @objc private func textfieldCancelAction(_ sender: Any) {
        presenter?.viewTriggeredCancelAction()
    }
    
    // MARK: - Private
    
    private func performInitialSetup() {
        alarmTextField.inputView = InputViewFactory.makeDatePickerView()
        alarmTextField.inputAccessoryView = InputViewFactory.makeDoneAccessoryView(target: self,
                                                                                   doneHandler: #selector(textfieldDoneAction(_:)),
                                                                                   cancelHandler: #selector(textfieldCancelAction(_:)))
    }
    
    private func setupTexts() {
        title = Localization.Home.title
        sleepTimerLabel.text = Localization.Home.sleepTimer
        alarmLabel.text = Localization.Home.alarm
    }
}

// MARK: - HomeInterface

extension HomeViewController: HomeInterface {
    
    func set(title: String) {
        self.title = title
    }
    
    func set(buttonTitle: String) {
        actionButton.setTitle(buttonTitle, for: .normal)
    }
    
    func set(sleepText: String) {
        sleepTimerValueLabel.text = sleepText
    }
    
    func set(alarmText: String) {
        alarmTextField.text = alarmText
    }
    
    func startEditingAlarm() {
        alarmTextField.becomeFirstResponder()
    }
    
    func endEditingAlarm() {
        alarmTextField.resignFirstResponder()
    }
}
