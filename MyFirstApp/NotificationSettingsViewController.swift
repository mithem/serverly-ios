//
//  NotificationSettingsViewController.swift
//  MyFirstApp
//
//  Created by Miguel Themann on 12.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationSettingsViewController: UIViewController {
    
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    @IBAction func enableNotificationsSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            enableNotifications()
        }
        else {
            disableNotifications()
        }
    }
    
    func enableNotifications() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound], completionHandler: {granted, error in
            if granted {
                let userDefaults = UserDefaults()
                userDefaults.set(true, forKey: "notifications")
                var dateComponents: DateComponents?
                DispatchQueue.main.sync {
                    dateComponents = Calendar.current.dateComponents([.hour, .minute], from: self.timePicker.date)
                }
                scheduleNotification(dateComponents: dateComponents!)
            }
            else {
                self.disableNotifications()
            }
            center.getNotificationSettings { settings in
                switch settings.authorizationStatus{
                case .denied:
                    let alert = UIAlertController(title: "Notifications disabled", message: "You disabled notifications in settings or elsewhere.", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
                    DispatchQueue.main.sync {
                        self.present(alert, animated: true, completion: nil)
                    }
                case .notDetermined:
                    let alert = UIAlertController(title: "Undetermined notification settings", message: "Please make sure to enable (or disable) notifications, preferably both in settings and this app", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
                    DispatchQueue.main.sync {
                        self.present(alert, animated: true, completion: nil)
                    }
                default:
                    let a = 0
                }
            }
        })
    }
    
    func disableNotifications() {
        let userDefaults = UserDefaults()
        userDefaults.set(false, forKey: "notifications")
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "notification settings"
    }
}
