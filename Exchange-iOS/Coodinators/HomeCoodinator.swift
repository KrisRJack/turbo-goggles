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
    let listingViewController = ListingViewController()
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = HomeTabBarController()
        tabBarController.viewControllers = [feedViewController, listingViewController]
        rootChangeAnimation()
        navigationController?.setViewControllers([tabBarController], animated: false)
    }
    
    private func rootChangeAnimation() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = .init(name: .easeInEaseOut)
        transition.type = .fade
        navigationController?.view.layer.add(transition, forKey: nil)
    }
    
}
