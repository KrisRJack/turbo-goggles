//
//  ForgotPasswordViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import UIKit

protocol ForgotPasswordNavigationDelegate {
    func success(from viewController: ForgotPasswordViewController)
    func presentError(from viewController: ForgotPasswordViewController, withMessage message: String)
}

final class ForgotPasswordViewController: AuthBaseController {
    
    private var viewModel: ForgotPasswordViewModel!
    private let tableViewCell: ForgotPasswordTableViewCell!
    public var navigationDelegate: ForgotPasswordNavigationDelegate?
    
    private let tableView: UITableView = .build { tableView in
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
    }
    
    init() {
        tableViewCell = ForgotPasswordTableViewCell()
        super.init(nibName: nil, bundle: nil)
        
        let credentials = ForgotPasswordViewModel.Credentials(
            email: { [weak self] in
                self?.tableViewCell.emailText
            }
        )
        
        viewModel = ForgotPasswordViewModel(credentials: credentials)
        
        viewModel.didSendResetEmail = { [weak self] in
            guard let self = self else { return }
            self.navigationDelegate?.success(from: self)
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
    
}

// MARK: - UITableViewDataSource

extension ForgotPasswordViewController: UITableViewDataSource {
    
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

// MARK: - ForgotPasswordTableViewCellDelegate

extension ForgotPasswordViewController: ForgotPasswordTableViewCellDelegate {
    
    func didTapSendEmailButton() {
        viewModel.sendEmailToResetPassword()
    }
    
}
