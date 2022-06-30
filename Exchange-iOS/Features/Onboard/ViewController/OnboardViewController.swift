//
//  OnboardViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/18/22.
//

import UIKit

protocol OnboardNavigationDelegate {
    func navigateToHome(from viewController: OnboardViewController, withUser user: UserStore)
    func presentError(from viewController: OnboardViewController, withMessage message: String)
}

final class OnboardViewController: AuthBaseController {
    
    private var viewModel: OnboardViewModel!
    private let tableViewCell: OnboardTableViewCell!
    public var navigationDelegate: OnboardNavigationDelegate?
    
    private let tableView: UITableView = .build { tableView in
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
    }
    
    init(authResult: AuthResult) {
        tableViewCell = OnboardTableViewCell()
        super.init(nibName: nil, bundle: nil)
        
        let input: OnboardViewModel.Input = OnboardViewModel.Input(
            firstName: { [weak self] in
                self?.tableViewCell.firstNameText
            },
            lastName: { [weak self] in
                self?.tableViewCell.lastNameText
            },
            username: { [weak self] in
                self?.tableViewCell.usernameText
            },
            dateOfBirth: { [weak self] in
                self?.tableViewCell.dobText
            }
        )
        
        viewModel = OnboardViewModel(authResult: authResult, input: input)
        
        viewModel.didOnboard = { [weak self] user in
            guard let self = self else { return }
            self.navigationDelegate?.navigateToHome(from: self, withUser: user)
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

extension OnboardViewController: UITableViewDataSource {
    
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

// MARK: - OnboardTableViewCellDelegate

extension OnboardViewController: OnboardTableViewCellDelegate {
    
    func didTapDoneButton() {
        viewModel.onboard()
    }
    
}
