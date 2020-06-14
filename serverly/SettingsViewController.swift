//
//  SettingsViewController.swift
//  serverly
//
//  Created by Miguel Themann on 11.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tfServerURL: UITextField!
    
    @IBOutlet weak var tfUsername: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "settings"
        let userDefaults = UserDefaults()
        
        tfServerURL.text = userDefaults.string(forKey: "serverURL")
        tfUsername.text = userDefaults.string(forKey: "username")
        tfPassword.text = userDefaults.string(forKey: "password")
    }
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        let userDefaults = UserDefaults()
        
        if tfServerURL.text == nil || tfServerURL.text == nil || tfUsername.text == nil {
            let alert = UIAlertController(title: "Invalid settings", message: "It appears that you didn't enter all fields; all are required though.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            userDefaults.set(tfServerURL.text, forKey: "serverURL")
            userDefaults.set(tfUsername.text, forKey: "username")
            userDefaults.set(tfPassword.text, forKey: "password")
            
            let alert = UIAlertController(title: "Applied data", message: "Your authentication data is now saved.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
