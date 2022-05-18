//
//  HomeCoodinator.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import UIKit

class HomeCoodinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    let feedViewController = FeedViewController()
    let listingViewController = ListingBaseViewController()
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = HomeTabBarController()
        tabBarController.viewControllers = [feedViewController, listingViewController]
        navigationController?.rootTransitionAnimation()
        navigationController?.setViewControllers([tabBarController], animated: false)
    }
    
}
