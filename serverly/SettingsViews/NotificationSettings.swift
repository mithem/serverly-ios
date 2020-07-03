//
//  NotificationSettings.swift
//  serverly
//
//  Created by Miguel Themann on 30.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import SwiftUI
import UserNotifications

struct NotificationSettings: View {
    
    var formatter = ISO8601DateFormatter()
    
    @State private var nNotifications = 0
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @State private var notificationDate = Date()
    @State private var startingNotificationDate = Date()
    
    var body: some View {
        Form {
            Section {
                Toggle("enable notifications", isOn: $notificationsEnabled)
                DatePicker("time", selection: $notificationDate, displayedComponents: .hourAndMinute)
                .disabled(!notificationsEnabled)
                .onAppear {
                    startingNotificationDate = notificationDate
                    notificationDate = formatter.date(from: UserDefaults().string(forKey: "notificationTimeString") ?? "") ?? Date()
                    refreshNotificationCount()
                }
                .onDisappear() {
                    apply()
                }
            }
            Section {
                Text("\(nNotifications) notifications scheduled.")
                    .foregroundColor(.secondary)
                Button("delete delivered and scheduled notifications", action: {
                    resetAllNotifications()
                    nNotifications = 0
                })
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("notifications")
        .navigationBarItems(trailing: Button(action: apply, label: {
            Image(systemName: "checkmark")
        }))
    }
    
    func apply() {
        if notificationDate != startingNotificationDate {
            scheduleNotification(date: notificationDate, completion: {_ in })
            UserDefaults().set(formatter.string(from: notificationDate), forKey: "notificationTimeString")
        }
        refreshNotificationCount()
    }
    
    func refreshNotificationCount() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            nNotifications = requests.count
        }
    }
}

struct NotificationSettings_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettings()
    }
}
