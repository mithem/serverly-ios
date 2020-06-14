//
//  Notifications.swift
//  serverly
//
//  Created by Miguel Themann on 12.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import Foundation
import UserNotifications

func scheduleNotification(dateComponents: DateComponents, callback: @escaping (Bool) -> Void){
    let userDefaults = UserDefaults()
    
    if userDefaults.bool(forKey: "notifications") {
        let content = UNMutableNotificationContent()
        content.title = "Some things might've changed"
        content.body = "Make sure to tune in so you're on the latest data."
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if error != nil {
                NSLog("An error occured while scheduling a notification: \(String(describing: error))")
                callback(false)
            }
            else {
                callback(true)
                NSLog("Successfully scheduled notification!")
            }
        }
    } else {
        callback(false)
    }
}
