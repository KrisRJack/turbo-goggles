//
//  AuthNavigationController.swift
//  Exchange
//
//  Created by Kristopher Jackson on 4/11/22.
//

import UIKit

class AuthNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        viewControllers.count > 1 ? .darkContent : .lightContent
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationBar.tintColor = .black
        navigationBar.shadowImage = UIImage()
        let image = UIImage(systemName: "arrow.left")
        navigationBar.backIndicatorImage = image
        navigationBar.backIndicatorTransitionMaskImage = image
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
