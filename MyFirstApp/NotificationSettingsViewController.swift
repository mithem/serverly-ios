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
    
    @IBOutlet weak var switchEnableNotifications: UISwitch!
    
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
                scheduleNotification(dateComponents: dateComponents!, callback: {success in
                    if success {
                        let alert = UIAlertController(title: "Scheduled notification", message: "The notification was successfully scheduled", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
                        DispatchQueue.main.sync {
                            self.switchEnableNotifications.isOn = true
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        let alert = UIAlertController(title: "Unable to schedule notification", message: "Sorry but an error occured or the notification wasn't scheduled for another reason", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
                        DispatchQueue.main.sync {
                            self.switchEnableNotifications.isOn = true
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
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
                        self.switchEnableNotifications.isOn = false
                        self.present(alert, animated: true, completion: nil)
                    }
                    UserDefaults().set(false, forKey: "notifications")
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
        switchEnableNotifications.isOn = UserDefaults().bool(forKey: "notifications")
    }
}
