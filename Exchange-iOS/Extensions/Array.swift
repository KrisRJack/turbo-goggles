//
//  Array.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 2/4/22.
//

import UIKit

extension Array where Element == NSLayoutConstraint {
    
    /// Activates each constraint in an array of `NSLayoutConstraint`.
    ///
    /// Example usage: `[view.heightAnchor.constraint(equalToConstant: 30), view.widthAnchor.constraint(equalToConstant: 30)].activate()`
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    /// Deactivates each constraint in an array of `NSLayoutConstraint`.
    ///
    /// Example usage: `[view.heightAnchor.constraint(equalToConstant: 30), view.widthAnchor.constraint(equalToConstant: 30)].deactivate()`
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
    
}
