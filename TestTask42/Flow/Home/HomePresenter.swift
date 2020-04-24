//
//  HomePresenter.swift
//  TestTask42
//
//  Created by Vitalii on 23.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import Foundation

protocol HomeInterface: AlertDisplaying {
    
    func set(title: String)
    func set(buttonTitle: String)
    func set(sleepText: String)
    func set(alarmText: String)
    func startEditingAlarm()
    func endEditingAlarm()
}

protocol HomeOutput: ViewLifecycle {
    
    func viewTriggeredSleepTimerAction()
    func viewTriggeredAlarmAction()
    func viewTriggeredButtonAction()
    func viewTriggeredDoneAction(date: Date)
    func viewTriggeredCancelAction()
}

class HomePresenter: NSObject {
    
    private weak var view: HomeInterface?
    private let router: HomeRouterProtocol
    private let mediaPlayerService: MediaPlayerService
    
    private var alarm: [DateComponents] = []
    private var sleepTime: SleepTime? {
        didSet {
            guard let view = view, let sleepTime = sleepTime else { return }
            view.set(sleepText: sleepTime.text)
        }
    }
    private var state: AppState? {
        didSet {
            guard let view = view, let state = state else { return }
            view.set(title: state.title)
            view.set(buttonTitle: state.button)
        }
    }
    
    init(withView view: HomeInterface, router: HomeRouterProtocol, mediaPlayerService: MediaPlayerService) {
        self.view = view
        self.router = router
        self.mediaPlayerService = mediaPlayerService
    }
}

// MARK: - HomeOutput 

extension HomePresenter: HomeOutput {
    
    func viewDidLoad() {
        state = .idle
        sleepTime = .off
        view?.set(alarmText: Date().toTimeString)
    }
    
    func viewTriggeredSleepTimerAction() {
        router.showSleepTimePicker { [weak self] sleepTime in
            self?.sleepTime = sleepTime
        }
    }
    
    func viewTriggeredAlarmAction() {
        view?.startEditingAlarm()
    }
    
    func viewTriggeredButtonAction() {
        state = state?.next
    }
    
    func viewTriggeredDoneAction(date: Date) {
        guard let view = view else { return }
        view.set(alarmText: date.toTimeString)
        view.endEditingAlarm()
    }
    
    func viewTriggeredCancelAction() {
        view?.endEditingAlarm()
    }
}

// MARK: - AppStateDelegate

extension HomePresenter: AppStateDelegate {
    
    func appStateDidChange(to state: AppState) {
        self.state = state
        if case .idle = state {
            view?.displayAlert(title: Localization.Alert.title)
        }
    }
}
