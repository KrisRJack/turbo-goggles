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
    let listingViewController = ListingTabBarViewController()
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        feedViewController.navigationDelegate = self
    }
    
    func start() {
        let tabBarController = HomeTabBarController()
        tabBarController.navigationDelegate = self
        tabBarController.viewControllers = [feedViewController, listingViewController]
        navigationController?.rootTransitionAnimation()
        navigationController?.setViewControllers([tabBarController], animated: false)
    }
    
    private func displayError(withMessage message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default))
        navigationController?.present(alertController, animated: true)
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

extension HomeCoodinator: FeedNavigationDelegate {
    
    func goToListingDetails(from viewController: FeedViewController, with listing: Listing) {
        let viewController = ListingDetailsViewController(model: listing)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentError(from viewController: FeedViewController, withMessage message: String) {
        displayError(withMessage: message)
    }
    
}
