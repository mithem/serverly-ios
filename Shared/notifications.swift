//
//  Notifications.swift
//  serverly
//
//  Created by Miguel Themann on 12.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import Foundation
import UserNotifications

func scheduleNotification(date: Date, completion: @escaping (NotificationSchedulingRequest) -> Void) {
    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
    scheduleNotification(dateComponents: components, completion: completion)
}

func scheduleNotification(dateComponents: DateComponents, completion: @escaping (NotificationSchedulingRequest) -> Void) {
    let userDefaults = UserDefaults()
    
    if userDefaults.bool(forKey: "notificationsEnabled") {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { successful, error in
            if error != nil {
                completion(.badStatus(status: .denied))
            }
        }
        registerNotification(dateComponents: dateComponents, completion: completion)
    } else {
        completion(.badStatus(status: .denied))
    }
}

private func registerNotification(dateComponents: DateComponents, completion: @escaping (NotificationSchedulingRequest) -> Void) {
    let content = UNMutableNotificationContent()
    content.title = "Some things might've changed"
    content.body = "Make sure to tune in so you're on the latest data."
    content.sound = .default
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
    let center = UNUserNotificationCenter.current()
    center.add(request) { error in
        if let error = error {
            NSLog("An error occured while scheduling a notification: \(error.localizedDescription)")
            completion(.error(error: error))
        }
        else {
            completion(.successful)
            NSLog("Successfully scheduled notification!")
        }
    }
}

func resetAllNotifications() {
    let center = UNUserNotificationCenter.current()
    center.removeAllPendingNotificationRequests()
    center.removeAllDeliveredNotifications()
}
