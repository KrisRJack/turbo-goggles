//
//  InboxViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 8/23/22.
//

import UIKit

protocol InboxNavigationDelegate {
    func didTapLeftBarButtonItem(from viewController: InboxViewController)
    func presentError(from viewController: InboxViewController, withMessage message: String)
}

final class InboxViewController: UIViewController {
    
    public var viewModel: InboxViewModel!
    public var navigationDelegate: InboxNavigationDelegate?
    
    private lazy var tableView: UITableView = .build { tableView in
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemBackground
        tableView.register(InboxCell.self, forCellReuseIdentifier: InboxCell.reuseIdentifier)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        var actions: InboxViewModel.Actions = .init()
        
        actions.reloadData = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        actions.showErrorMessage = { [weak self] message in
            guard let self = self else { return }
            self.navigationDelegate?.presentError(from: self, withMessage: message)
        }
        
        // TODO: Handle error. Pass through `init()`
        let service: InboxService = try! .init(forUser: UserStore.current!)
        
        self.viewModel = InboxViewModel(
            actions: actions,
            service: service
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inbox"
        view.backgroundColor = .systemBackground
        setUpViews()
        viewModel?.viewDidLoad()
    }
    
    private func setUpViews() {
        view.addSubviews(tableView)
        tableView.edges(equalTo: view)
    }
    
}

// MARK: - UITableViewDataSource

extension InboxViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InboxCell.reuseIdentifier, for: indexPath)
        (cell as? InboxCell)?.configure(with: viewModel.item(atIndexPath: indexPath))
        return cell
    }
    
}
