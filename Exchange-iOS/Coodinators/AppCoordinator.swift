//
//  AppCoordinator.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        switch AppViewModel.currentScene() {
        case .auth:
        
            guard let navigationController = navigationController else { return }
            let authCoordinator = AuthCoordinator(navigationController)
            authCoordinator.delegate = self
            authCoordinator.start()
            childCoordinators = [authCoordinator]
            
        case .home:
            
            guard let navigationController = navigationController else { return }
            let homeCoordinator = HomeCoordinator(navigationController)
            homeCoordinator.start()
            childCoordinators = [homeCoordinator]
            
        }
    }
    
}

extension AppCoordinator: AuthCoordinatorDelegate {
    
    func navigateToHomeCoordinator(from coordinator: AuthCoordinator) {
        
        guard let navigationController = navigationController else { return }
        let homeCoordinator = HomeCoordinator(navigationController)
        homeCoordinator.start()
        childCoordinators = [homeCoordinator]
        
    }
    
}
