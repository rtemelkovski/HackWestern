//
//  Extensions.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-15.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    class var consumed : UIColor {
        return UIColor(red:0.31, green:0.23, blue:0.47, alpha:1.0)
    }
    class var missed : UIColor {
        return UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0)
    }
    class var approaching : UIColor {
        return UIColor(red:0.80, green:0.80, blue:0.00, alpha:1.0)
    }
    class var pending : UIColor {
        return  UIColor(red:0.63, green:0.63, blue:0.63, alpha:1.0)
    }
}
