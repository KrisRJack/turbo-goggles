//
//  ForgotPasswordViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import UIKit

final class ForgotPasswordViewController: AuthBaseController {
    
    private let tableViewCell: ForgotPasswordTableViewCell!
    
    private let tableView: UITableView = .build { tableView in
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
    }
    
    init() {
        tableViewCell = ForgotPasswordTableViewCell()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.fill(with: tableView)
        tableView.dataSource = self
    }
    
}

// MARK: - UITableViewDataSource

extension ForgotPasswordViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableViewCell
    }
    
}
