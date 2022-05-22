//
//  NewListingViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/21/22.
//

import UIKit

protocol NewListingNavigationDelegate {
    func goToGetMedia(from viewController: NewListingViewController)
}

final class NewListingViewController: UITableViewController {
    
    var photos: ReferenceArray<Data>
    let listingPhotosViewController: ListingPhotosViewController
    var navigationDelegate: NewListingNavigationDelegate?
    
    init(photos imageData: ReferenceArray<Data>) {
        photos = imageData
        listingPhotosViewController = ListingPhotosViewController(imageData: imageData)
        super.init(nibName: nil, bundle: nil)
        listingPhotosViewController.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        configureTableViewHeader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if window?.safeAreaInsets.bottom ?? 0 > 0 {
            self.view.layer.cornerRadius = 0
            self.view.layer.masksToBounds = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if window?.safeAreaInsets.bottom ?? 0 > 0 {
            view.layer.cornerRadius = 30
            view.layer.masksToBounds = true
        }
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .darkThemeColor
        navigationController?.topViewController?.title = "New Listing"
    }
    
    private func configureTableViewHeader() {
        tableView.tableHeaderView = UIView()
        tableView.tableHeaderView?.addSubviews(listingPhotosViewController.view)
        tableView.tableHeaderView?.frame.size.height = 220
        addChild(listingPhotosViewController)
        listingPhotosViewController.didMove(toParent: self)
    }
    
}

// MARK: - ListingPhotosDelegate

extension NewListingViewController: ListingPhotosDelegate {
    
    func shouldGetMedia() {
        navigationDelegate?.goToGetMedia(from: self)
    }
    
}
