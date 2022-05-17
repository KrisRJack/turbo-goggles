//
//  UINavigationController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/17/22.
//

import UIKit

extension UINavigationController {
    
    public func rootTransitionAnimation() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = .init(name: .easeInEaseOut)
        transition.type = .fade
        view.layer.add(transition, forKey: nil)
    }
    
}
