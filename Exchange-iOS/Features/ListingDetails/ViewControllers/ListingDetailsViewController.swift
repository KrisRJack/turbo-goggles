//
//  ListingDetailsViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/18/22.
//

import UIKit

final class ListingDetailsViewController: UIViewController {
    
    private let viewModel: ListingDetailsViewModel
    
    private lazy var tableView: UITableView = .build { tableView in
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(ListingDetailsHeaderCell.self, forCellReuseIdentifier: ListingDetailsHeaderCell.reuseIdentifier)
        tableView.register(ListingDetailsImageCell.self, forCellReuseIdentifier: ListingDetailsImageCell.reuseIdentifier)
    }
    
    init(model: Listing) {
        viewModel = ListingDetailsViewModel(model: model)
        super.init(nibName: nil, bundle: nil)
        viewModel.reloadData = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        view.backgroundColor = .systemBackground
        addTableViewToView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
    private func addTableViewToView() {
        view.addSubviews(tableView)
        [tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        ].activate()
    }
    
}

// MARK: - UITableViewDataSource

extension ListingDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection[section] ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item.isFirstIndex {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListingDetailsHeaderCell.reuseIdentifier, for: indexPath)
            (cell as? ListingDetailsHeaderCell)?.configure(with: viewModel.headerModel, parentViewController: self)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ListingDetailsImageCell.reuseIdentifier, for: indexPath)
        (cell as? ListingDetailsImageCell)?.configure(with: viewModel.generateModel(forItemAtIndex: indexPath.item - 1))
        return cell
    }
    
    
}
