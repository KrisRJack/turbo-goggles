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
            navigationController.overrideUserInterfaceStyle = .light
            let authCoordinator = AuthCoordinator(navigationController)
            authCoordinator.delegate = self
            authCoordinator.start()
            childCoordinators = [authCoordinator]
            
        case .home(let user):
            
            // TODO: Handle this error
            ChatService.configure(forUser: user)
            
            guard let navigationController = navigationController else { return }
            navigationController.overrideUserInterfaceStyle = .unspecified
            let homeCoordinator = HomeCoordinator(navigationController)
            homeCoordinator.start()
            childCoordinators = [homeCoordinator]
            
        }
    }
    
}

extension AppCoordinator: AuthCoordinatorDelegate {
    
    func navigateToHomeCoordinator(from coordinator: AuthCoordinator, withUser user: UserStore) {
        
        // TODO: Handle this error
        ChatService.configure(forUser: user)
        
        guard let navigationController = navigationController else { return }
        navigationController.overrideUserInterfaceStyle = .unspecified
        let homeCoordinator = HomeCoordinator(navigationController)
        homeCoordinator.start()
        childCoordinators = [homeCoordinator]
        
    }
    
}
