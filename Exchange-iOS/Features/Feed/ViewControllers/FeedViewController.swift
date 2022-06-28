//
//  FeedViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import UIKit

protocol FeedNavigationDelegate {
    func goToListingDetails(from viewController: FeedViewController, with listing: Listing)
    func presentError(from viewController: FeedViewController, withMessage message: String)
}

final class FeedViewController: UIViewController {
    
    public var navigationDelegate: FeedNavigationDelegate?
    private var viewModel: FeedViewModel
    
    private lazy var leftBarItem = UIBarButtonItem(
        image: UIImage(
            systemName: "paperplane",
            withConfiguration: UIImage.SymbolConfiguration(weight: .medium)
        ),
        style: .plain,
        target: self,
        action: nil
    )
    
    private lazy var rightBarItem = UIBarButtonItem(
        image: UIImage(
            systemName: "bag",
            withConfiguration: UIImage.SymbolConfiguration(weight: .medium)
        ),
        style: .plain,
        target: self,
        action: nil
    )
    
    private let logo: UIImageView = .build { imageView in
        let inset: CGFloat = -4
        imageView.tintColor = .darkThemeColor
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Logo-Text")?
            .withAlignmentRectInsets(UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0))
    }
    
    private lazy var tableView: UITableView = .build { tableView in
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .secondarySystemBackground
        tableView.register(PKListingCell.self, forCellReuseIdentifier: PKListingCell.reuseIdentifier)
        // Add refresh control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
    }
    
    init() {
        viewModel = FeedViewModel()
        super.init(nibName: nil, bundle: nil)
        setUpTabBarItem()
        
        viewModel.reloadData = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        }
        
        viewModel.error = { [weak self] error in
            guard let self = self else { return }
            self.navigationDelegate?.presentError(from: self, withMessage: error)
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableViewToView()
        configureBarButtonItems()
        setUpNavigationBarAppearance()
        viewModel.loadInitialBatch()
        view.backgroundColor = .systemBackground
    }
    
    private func addTableViewToView() {
        view.addSubviews(tableView)
        [tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
         tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ].activate()
    }
    
    private func setUpTabBarItem() {
        tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
    }
    
    private func configureBarButtonItems() {
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.rightBarButtonItem = rightBarItem
        navigationItem.titleView = logo
    }
    
    private func setUpNavigationBarAppearance() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func pullToRefresh() {
        viewModel.paginateNewerBatch()
    }
    
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection[section] ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        (cell as? PKListingCell)?.setParentViewController(to: self)
        (cell as? PKListingCell)?.configure(with: PKListingCell.Model(
            headerText: headerText,
            infoBanner: itemInfo,
            photoReferences: listing.imageReferences
        ))
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let listing = viewModel.listingForCell(at: indexPath)
        navigationDelegate?.goToListingDetails(from: self, with: listing)
    }
    
}
