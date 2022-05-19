//
//  ListingCoordinator.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/17/22.
//

import UIKit

protocol ListingCoordinatorDelegate {
    func didFinish(from coordinator: ListingCoordinator)
}

final class ListingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var navigationDelegate: ListingCoordinatorDelegate?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let cameraViewController = CameraViewController()
        cameraViewController.navigationDelegate = self
        navigationController?.viewControllers = [cameraViewController]
    }
    
}

extension ListingCoordinator: CameraNavigationDelegate {
    
    func showPermissionMessage(from viewController: CameraViewController) {
        let title = NSLocalizedString("CAMERA_DISABLED_HEADER", comment: "Header")
        let message = NSLocalizedString("CAMERA_DISABLED_TEXT", comment: "General")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissActionTitle = NSLocalizedString("DISMISS_BUTTON", comment: "Button")
        let dismissAction = UIAlertAction(title: dismissActionTitle, style: .cancel, handler: { [weak self] action in
            guard let self = self else { return }
            self.navigationDelegate?.didFinish(from: self)
        })
        
        let settingsActionTitle = NSLocalizedString("GO_TO_SETTING_BUTTON", comment: "Button")
        let settingsAction = UIAlertAction(title: settingsActionTitle, style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { completed in
                if completed { self.navigationDelegate?.didFinish(from: self) }
            }
         })
            
        alertController.addAction(settingsAction)
        alertController.addAction(dismissAction)
                                           
        navigationController?.present(alertController, animated: true)
    }
    
    func presentError(from viewController: CameraViewController, withMessage message: String) {
        
    }
    
    
    
    
}
