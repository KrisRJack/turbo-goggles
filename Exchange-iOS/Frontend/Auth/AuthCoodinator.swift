//
//  AuthCoodinator.swift
//  Exchange
//
//  Created by Kristopher Jackson on 4/10/22.
//

import UIKit

protocol AuthCoordinatorDelegate {
    func navigateToHomeCoordinator(from coordinator: AuthCoordinator)
}

class AuthCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    public var delegate: AuthCoordinatorDelegate?
    private let navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = OpeningViewController()
        viewController.navigationDelegate = self
        navigationController?.viewControllers = [viewController]
    }
    
    private func displayError(withMessage message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default))
        navigationController?.present(alertController, animated: true)
    }
    
}

extension AuthCoordinator: OpeningNavigationDelegate {
    
    func navigateToLogin(from: OpeningViewController) {
        let viewController = LoginViewController()
        viewController.navigationDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func navigateToSignUp(from: OpeningViewController) {
        let viewController = SignUpViewController()
        viewController.navigationDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension AuthCoordinator: LoginNavigationDelegate {
    
    func navigateToHome(from viewController: LoginViewController) {
        delegate?.navigateToHomeCoordinator(from: self)
    }
    
    func navigateToOnboard(from viewController: LoginViewController, withResult result: AuthResult) {
        let viewController = OnboardViewController(authResult: result)
        viewController.navigationDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentError(from viewController: LoginViewController, withMessage message: String) {
        displayError(withMessage: message)
    }
    
    func navigateToSignUp(from viewController: LoginViewController) {
        let viewController = SignUpViewController()
        viewController.navigationDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
        guard let count = navigationController?.viewControllers.count, count > 1 else { return }
        navigationController?.viewControllers.remove(at: count - 2)
    }
    
}

extension AuthCoordinator: SignUpNavigationDelegate {
    
    func navigateToOnboard(from viewController: SignUpViewController, withResult result: AuthResult) {
        let viewController = OnboardViewController(authResult: result)
        viewController.navigationDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func presentError(from viewController: SignUpViewController, withMessage message: String) {
        displayError(withMessage: message)
    }
    
    func navigateToLogIn(from viewController: SignUpViewController) {
        let viewController = LoginViewController()
        viewController.navigationDelegate = self
        navigationController?.pushViewController(viewController, animated: true)
        guard let count = navigationController?.viewControllers.count, count > 1 else { return }
        navigationController?.viewControllers.remove(at: count - 2)
    }
    
    
}

extension AuthCoordinator: OnboardNavigationDelegate {
    
    func navigateToHome(from viewController: OnboardViewController) {
        delegate?.navigateToHomeCoordinator(from: self)
    }
    
    func presentError(from viewController: OnboardViewController, withMessage message: String) {
        displayError(withMessage: message)
    }
    
}
