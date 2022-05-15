//
//  Array.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 2/4/22.
//

import UIKit

extension Array where Element == NSLayoutConstraint {
    
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
    
}
