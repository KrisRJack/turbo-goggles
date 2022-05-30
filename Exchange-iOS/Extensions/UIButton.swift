//
//  UIButton.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/30/22.
//

import UIKit

extension UIButton {
    
    public func lock() {
        isEnabled = false
    }
    
    public func unlock() {
        isEnabled = true
    }
    
}
