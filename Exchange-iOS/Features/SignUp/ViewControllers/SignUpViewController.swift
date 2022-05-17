//
//  SignUpViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/18/22.
//

import UIKit

protocol SignUpNavigationDelegate {
    func navigateToLogIn(from viewController: SignUpViewController)
    func presentError(from viewController: SignUpViewController, withMessage message: String)
    func navigateToOnboard(from viewController: SignUpViewController, withResult result: AuthResult)
}

final class SignUpViewController: AuthBaseController {
    
    private var viewModel: SignUpViewModel!
    private let tableViewCell: SignUpTableViewCell!
    public var navigationDelegate: SignUpNavigationDelegate?
    
    private let tableView: UITableView = .build { tableView in
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
    }
    
    init() {
        tableViewCell = SignUpTableViewCell()
        super.init(nibName: nil, bundle: nil)
        
        let credentials: SignUpViewModel.Credentials = SignUpViewModel.Credentials(
            email: { [weak self] in
                self?.tableViewCell.emailText
            },
            password: { [weak self] in
                self?.tableViewCell.passwordText
            }
        )
        
        viewModel = SignUpViewModel(credentials: credentials)
        
        viewModel.didSignUp = { [weak self] result in
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

extension SignUpViewController: UITableViewDataSource {
    
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


// MARK: - SignUpTableViewCellDelegate

extension SignUpViewController: SignUpTableViewCellDelegate {
    
    func didTapSignUpButton() {
        viewModel.signUp()
    }
    
    func didTapLogInButton() {
        navigationDelegate?.navigateToLogIn(from: self)
    }
    
}
