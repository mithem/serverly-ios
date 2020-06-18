//
//  CustomizationSettingsViewController.swift
//  serverly
//
//  Created by Miguel Themann on 18.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import UIKit

class CustomizationSettingsViewController: UIViewController {
    
    @IBOutlet weak var scMethod: UISegmentedControl!
    
    @IBOutlet weak var scColor: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "customization"
        loadSettings()
    }
    @IBAction func scMethodChanged(_ sender: UISegmentedControl) {
        scColor.selectedSegmentIndex = UserDefaults().integer(forKey: getKeyName(sender.selectedSegmentIndex))
    }
    
    @IBAction func scColorChanged(_ sender: UISegmentedControl) {
        apply()
    }
    
    func loadSettings() {
        let userDefaults = UserDefaults()
        scMethod.selectedSegmentIndex = 0
        scColor.selectedSegmentIndex = userDefaults.integer(forKey: "colorForGET")
    }
    
    func getKeyName(_ i: Int) -> String {
        switch scMethod.selectedSegmentIndex {
        case 0:
            return  "colorForGET"
        case 1:
            return "colorForPOST"
        case 2:
            return "colorForPUT"
        case 3:
            return "colorForDELETE"
        default:
            return ""
        }
    }
    
    func apply() {
        let userDefaults = UserDefaults()
        userDefaults.set(scColor.selectedSegmentIndex, forKey: getKeyName(scColor.selectedSegmentIndex))
    }
}
