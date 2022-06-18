//
//  FeedViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import UIKit

protocol FeedNavigationDelegate {
    func presentError(from viewController: FeedViewController, withMessage message: String)
}

final class FeedViewController: UITableViewController {
    
    public var navigationDelegate: FeedNavigationDelegate?
    private var viewModel: FeedViewModel
    
    init() {
        viewModel = FeedViewModel()
        super.init(nibName: nil, bundle: nil)
        setUpTabBarItem()
        
        viewModel.reloadData = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        
        viewModel.error = { [weak self] error in
            guard let self = self else { return }
            self.navigationDelegate?.presentError(from: self, withMessage: error)
            self.refreshControl?.endRefreshing()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureRefresh()
        viewModel.loadInitialBatch()
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(PKListingCell.self, forCellReuseIdentifier: PKListingCell.reuseIdentifier)
    }
    
    private func setUpTabBarItem() {
        tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
    }
    
    private func configureRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc private func pullToRefresh() {
        viewModel.paginateNewerBatch()
    }
    
}

// MARK: - UITableViewDataSource

extension FeedViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection[section] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listing = viewModel.listingForCell(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: PKListingCell.reuseIdentifier, for: indexPath)
        
        let header = PKHeader.Model(
            displayName: listing.displayName,
            username: listing.username,
            datePosted: listing.created,
            imageReference: listing.userImageReference
        )
        
        let headerText = PKHeaderText.Model(
            header: header,
            text: listing.description
        )
        
        let itemInfo = PKInfoBanner.Model(
            price: listing.formattedPrice,
            title: listing.header,
            size: listing.size,
            condition: listing.condition,
            category: listing.category
        )
        
        (cell as? PKListingCell)?.configure(with: PKListingCell.Model(
            headerText: headerText,
            infoBanner: itemInfo,
            photoReferences: listing.imageReferences
        ), from: self)
        
        return cell
    }
    
}
