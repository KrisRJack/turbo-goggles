//
//  ListingDetailsViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/18/22.
//

import UIKit

final class ListingDetailsViewController: UIViewController {
    
    private let listing: Listing
    
    private lazy var tableView: UITableView = .build { tableView in
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(ListingDetailsHeaderCell.self, forCellReuseIdentifier: ListingDetailsHeaderCell.reuseIdentifier)
    }
    
    init(model: Listing) {
        listing = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = listing.header
        view.backgroundColor = .systemBackground
        addTableViewToView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let header = tableView.tableHeaderView else { return }
        header.frame.size.height = header.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: .zero)).height
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListingDetailsHeaderCell.reuseIdentifier, for: indexPath)
        (cell as? ListingDetailsHeaderCell)?.configure(with: ListingDetailsHeaderView.Model(
            header: PKHeader.Model(
                displayName: listing.displayName,
                username: listing.username,
                datePosted: listing.created,
                imageReference: listing.userImageReference
            ),
            formattedPrice: listing.formattedPrice,
            title: listing.header,
            description: listing.description,
            size: listing.size,
            condition: listing.condition,
            category: listing.category,
            tags: listing.tags
        ), parentViewController: self)
        return cell
    }
    
    
}
