//
//  NewListingViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/21/22.
//

import UIKit

protocol NewListingNavigationDelegate {
    func goToGetMedia(from viewController: NewListingViewController)
    func goToEditImage(from viewController: NewListingViewController, at indexPath: IndexPath, with images: ReferenceArray<ListingImage>)
}

final class NewListingViewController: UITableViewController {
    
    var images: ReferenceArray<ListingImage>
    let listingPhotosViewController: ListingPhotosViewController
    var navigationDelegate: NewListingNavigationDelegate?
    
    init(images imageData: ReferenceArray<ListingImage>) {
        images = imageData
        listingPhotosViewController = ListingPhotosViewController(images: imageData)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if window?.safeAreaInsets.bottom ?? 0 > 0 {
            view.layer.cornerRadius = 30
            view.layer.masksToBounds = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if window?.safeAreaInsets.bottom ?? 0 > 0 {
            view.layer.cornerRadius = 0
            view.layer.masksToBounds = true
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
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
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
    
    func shouldEditImage(at indexPath: IndexPath) {
        navigationDelegate?.goToEditImage(from: self, at: indexPath, with: images)
    }
    
}
