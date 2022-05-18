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
        tabBarController.navigationDelegate = self
        tabBarController.viewControllers = [feedViewController, listingViewController]
        navigationController?.rootTransitionAnimation()
        navigationController?.setViewControllers([tabBarController], animated: false)
    }
    
}

extension HomeCoodinator: HomeTabBarControllerNavigationDelegate {
    
    func navigateToCreateListing() {
        let listingNavigationController = UINavigationController()
        listingNavigationController.modalPresentationStyle = .fullScreen
        let listingCoordinator = ListingCoordinator(listingNavigationController)
        listingCoordinator.navigationDelegate = self
        listingCoordinator.start()
        childCoordinators.append(listingCoordinator)
        navigationController?.present(listingNavigationController, animated: true)
    }
    
}

extension HomeCoodinator: ListingCoordinatorDelegate {
    
    func didFinish(from coordinator: ListingCoordinator) {
        navigationController?.dismiss(animated: true)
        childCoordinators.removeLast()
    }
    
}
