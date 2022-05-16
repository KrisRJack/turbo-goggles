//
//  HomeCoodinator.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import UIKit

class HomeCoodinator {
    
    var childCoordinators: [Coordinator] = []
    private let tabBarController: UITabBarController?
    
    required init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        let viewController = FeedViewController()
        tabBarController?.viewControllers = [viewController]
    }
    
}
