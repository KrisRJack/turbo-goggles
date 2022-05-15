//
//  AppCoodinator.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import UIKit

final class AppCoordinator {
    
    private var window: UIWindow?
    
    private var windowScene: UIWindowScene? {
        set { window?.windowScene = newValue }
        get { return window?.windowScene }
    }
    
    private var rootViewController: UIViewController? {
        set { window?.rootViewController = newValue }
        get { return window?.rootViewController }
    }
    
    init(window: UIWindow, windowScene: UIWindowScene) {
        self.window = window
        self.windowScene = windowScene
    }
    
    func start() {
        switch AppViewModel.currentScene() {
        case .auth:
            rootViewController = AuthNavigationController()
            guard let navigationController = rootViewController as? UINavigationController else { return }
            let authCoordinator = AuthCoordinator(navigationController: navigationController)
            authCoordinator.delegate = self
            authCoordinator.start()
        case .home:
            rootViewController = HomeTabBarController()
            guard let tabBarController = rootViewController as? UITabBarController else { return }
            let homeCoodinator = HomeCoodinator(tabBarController: tabBarController)
            homeCoodinator.start()
        }
        makeKeyAndVisible()
    }
    
    private func makeKeyAndVisible(withAnimation: Bool = false) {
        guard let window = window else { return }
        withAnimation
        ? UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
        : window.makeKeyAndVisible()
    }
    
}

extension AppCoordinator: AuthCoordinatorDelegate {
    
    func navigateToHomeCoordinator(from coordinator: AuthCoordinator) {
        rootViewController = HomeTabBarController()
        makeKeyAndVisible(withAnimation: true)
    }
    
}
