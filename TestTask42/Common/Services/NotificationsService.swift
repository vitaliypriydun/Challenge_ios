//
//  NotificationsService.swift
//  TestTask42
//
//  Created by Vitalii on 24.04.2020.
//  Copyright © 2020 com.vitalii_pryidun. All rights reserved.
//

import UIKit
import UserNotifications

protocol NotificationsService: AlarmService {

    func requestPermissions()
}

class DefaultNotificationService: NSObject {
    
    private weak var delegate: AppStateDelegate?
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - NotificationsService

extension DefaultNotificationService: NotificationsService {
    
    func set(delegate: AppStateDelegate) {
        self.delegate = delegate
    }
   
    func scheduleAlarm(at date: Date) {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let notification = UNMutableNotificationContent()
        notification.title = Localization.Alert.title
        notification.sound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "alarm.m4a"))
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
        UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)
    }
    
    func stopAlarm() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            if granted == false || error != nil {
                self?.delegate?.errorOccured(Localization.Error.failedToStartRecording)
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension DefaultNotificationService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard UIApplication.shared.applicationState != .active else { return }
        let options: UNNotificationPresentationOptions = [.alert, .sound, .badge]
        completionHandler(options)
    }
}
