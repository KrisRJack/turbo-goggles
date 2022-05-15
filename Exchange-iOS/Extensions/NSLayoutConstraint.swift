//
//  NSLayoutConstraint.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 2/4/22.
//

import UIKit

extension NSLayoutConstraint {
    
    func activate() {
        self.isActive = true
    }
    
    func deactivate() {
        self.isActive = false
    }
    
}
