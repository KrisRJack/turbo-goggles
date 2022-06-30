//
//  LoginController.swift
//  Exchange
//
//  Created by Kristopher Jackson on 4/10/22.
//

import UIKit

protocol LoginNavigationDelegate {
    func navigateToHome(from viewController: LoginViewController, withUser user: UserStore)
    func navigateToSignUp(from viewController: LoginViewController)
    func navigateToForgotPassword(from viewController: LoginViewController)
    func presentError(from viewController: LoginViewController, withMessage message: String)
    func navigateToOnboard(from viewController: LoginViewController, withResult result: AuthResult)
}

final class LoginViewController: AuthBaseController {
    
    private var viewModel: LoginViewModel!
    private let tableViewCell: LoginTableViewCell!
    public var navigationDelegate: LoginNavigationDelegate?
    
    private let tableView: UITableView = .build { tableView in
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
    }
    
    init() {
        tableViewCell = LoginTableViewCell()
        super.init(nibName: nil, bundle: nil)
        
        let credentials: LoginViewModel.Credentials = LoginViewModel.Credentials(
            email: { [weak self] in
                self?.tableViewCell.emailText
            },
            password: { [weak self] in
                self?.tableViewCell.passwordText
            }
        )
        
        viewModel = LoginViewModel(credentials: credentials)
        
        viewModel.didLogInWithUser = { [weak self] user in
            guard let self = self else { return }
            self.navigationDelegate?.navigateToHome(from: self, withUser: user)
        }
        
        viewModel.didLogInWithoutUser = { [weak self] result in
            guard let self = self else { return }
            self.navigationDelegate?.navigateToOnboard(from: self, withResult: result)
        }
        
        viewModel.error = { [weak self] error in
            guard let self = self else { return }
            self.navigationDelegate?.presentError(from: self, withMessage: error)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.fill(with: tableView)
        tableView.dataSource = self
        tableViewCell.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.signOut()
    }
    
}

// MARK: - UITableViewDataSource

extension LoginViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableViewCell
    }
    
}

// MARK: - LoginTableViewCellDelegate

extension LoginViewController: LoginTableViewCellDelegate {
    
    func didTapLogInButton() {
        viewModel?.logIn()
    }
    
    func didTapSignUpButton() {
        navigationDelegate?.navigateToSignUp(from: self)
    }
    
    func didTapForgotPasswordButton() {
        navigationDelegate?.navigateToForgotPassword(from: self)
    }
    
}
