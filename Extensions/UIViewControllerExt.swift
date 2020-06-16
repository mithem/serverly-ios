//
//  UIViewControllerExt.swift
//  serverly
//
//  Created by Miguel Themann on 16.06.20.
//  Copyright © 2020 Miguel Themann. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentOKAlertOnMainThread(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.sync {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
