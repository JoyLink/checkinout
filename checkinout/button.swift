//
//  button.swift
//  checkinout
//
//  Created by Joy on 3/15/17.
//  Copyright © 2017 me. All rights reserved.
//
import UIKit

private var customized = false

extension UIButton {
    @IBInspectable var customise: Bool {
        get {
            return customized
        } set {
            customized = newValue
            if customized {
                self.layer.cornerRadius = 7.0
            } else {
                self.layer.cornerRadius = 0.0
            }
        }
    }
}
