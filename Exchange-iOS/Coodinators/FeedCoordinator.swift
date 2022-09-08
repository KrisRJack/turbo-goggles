//
//  FeedCoordinator.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/27/22.
//

import UIKit

protocol FeedCoordinatorDelegate { }

class FeedCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    public var delegate: FeedCoordinatorDelegate?
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = FeedViewController()
        viewController.navigationDelegate = self
        navigationController?.viewControllers = [viewController]
    }
    
    private func displayError(withMessage message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default))
        navigationController?.present(alertController, animated: true)
    }
    
}

extension FeedCoordinator: FeedNavigationDelegate {
    
    func goToInbox(from viewController: FeedViewController) {
        let viewController = InboxViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goToMessaging(from viewController: FeedViewController, with listing: Listing) {
        let viewController = MessagingViewController(listing: listing)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goToListingDetails(from viewController: FeedViewController, with listing: Listing) {
        let viewController = ListingDetailsViewController(model: listing)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentError(from viewController: FeedViewController, withMessage message: String) {
        displayError(withMessage: message)
    }
    
}
