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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var innerScrollViewGroup: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "settings"
        let userDefaults = UserDefaults()
        
        tfServerURL.text = userDefaults.string(forKey: "serverURL")
        tfUsername.text = userDefaults.string(forKey: "username")
        tfPassword.text = userDefaults.string(forKey: "password")
        
        let fullScreenRect = UIScreen.main.bounds
        scrollView.contentSize = CGSize(width: fullScreenRect.width, height: innerScrollViewGroup.frame.height + 50) // Navbar title
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        apply()
    }
    
    func apply(){
        if tfServerURL.text != nil && tfUsername.text != nil && tfPassword.text != nil && tfServerURL.text != "" && tfUsername.text != "" && tfPassword.text != ""{
            let userDefaults = UserDefaults()
            userDefaults.set(tfServerURL.text, forKey: "serverURL")
            userDefaults.set(tfUsername.text, forKey: "username")
            userDefaults.set(tfPassword.text, forKey: "password")
        }
    }
}
