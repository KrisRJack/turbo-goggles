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
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(MaterialTextViewCell.self, forCellReuseIdentifier: MaterialTextViewCell.reuseIdentifier)
        tableView.register(MaterialTextFieldCell.self, forCellReuseIdentifier: MaterialTextFieldCell.reuseIdentifier)
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
        tableView.tableHeaderView?.frame.size.height = 244
        addChild(listingPhotosViewController)
        listingPhotosViewController.didMove(toParent: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = form[indexPath.row]
        
        switch data.fieldType {
        case .textfield:
            let cell = tableView.dequeueReusableCell(withIdentifier: MaterialTextFieldCell.reuseIdentifier, for: indexPath)
            (cell as? MaterialTextFieldCell)?.title = data.title
            (cell as? MaterialTextFieldCell)?.placeholder = data.placeholder
            (cell as? MaterialTextFieldCell)?.subtext = data.subtitle
            (cell as? MaterialTextFieldCell)?.setTextColor(to: .label)
            (cell as? MaterialTextFieldCell)?.setPrimaryColor(to: .lightThemeColor)
            (cell as? MaterialTextFieldCell)?.setSecondaryColor(to: .secondaryLabel)
            return cell
            
        case .textView:
            let cell = tableView.dequeueReusableCell(withIdentifier: MaterialTextViewCell.reuseIdentifier, for: indexPath)
            (cell as? MaterialTextViewCell)?.title = data.title
            (cell as? MaterialTextViewCell)?.placeholder = data.placeholder
            (cell as? MaterialTextViewCell)?.subtext = data.subtitle
            (cell as? MaterialTextViewCell)?.setTextColor(to: .label)
            (cell as? MaterialTextViewCell)?.setPrimaryColor(to: .lightThemeColor)
            (cell as? MaterialTextViewCell)?.setSecondaryColor(to: .secondaryLabel)
            return cell
        }
        
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

// MARK: - Form

extension NewListingViewController {
    
    enum FieldType {
        case textfield
        case textView
    }
    
    struct Form {
        let title: String
        let subtitle: String?
        let placeholder: String
        let fieldType: FieldType
    }
    
    var form: [Form] {
        [
            Form(
                title: NSLocalizedString("LISTING_TITLE_HEADER", comment: "Header"),
                subtitle: nil,
                placeholder: NSLocalizedString("LISTING_TITLE_PLACEHOLDER", comment: "Placeholder"),
                fieldType: .textfield
            ),
            
            Form(
                title: NSLocalizedString("LISTING_PRICE_HEADER", comment: "Header"),
                subtitle: nil,
                placeholder: NSLocalizedString("LISTING_PRICE_PLACEHOLDER", comment: "Placeholder"),
                fieldType: .textfield
            ),
            
            Form(
                title: NSLocalizedString("LISTING_DESCRIPTION_HEADER", comment: "Header"),
                subtitle: NSLocalizedString("LISTING_DESCRIPTION_TEXT", comment: "General"),
                placeholder: NSLocalizedString("LISTING_DESCRIPTION_PLACEHOLDER", comment: "Placeholder"),
                fieldType: .textView
            ),
            
            Form(
                title: NSLocalizedString("LISTING_SIZE_HEADER", comment: "Header"),
                subtitle: NSLocalizedString("LISTING_SIZE_TEXT", comment: "Placeholder"),
                placeholder: NSLocalizedString("LISTING_SIZE_PLACEHOLDER", comment: "Placeholder"),
                fieldType: .textfield
            ),
            
            Form(
                title: NSLocalizedString("LISTING_TAG_HEADER", comment: "Header"),
                subtitle: NSLocalizedString("LISTING_TAG_TEXT", comment: "Placeholder"),
                placeholder: NSLocalizedString("LISTING_TAG_PLACEHOLDER", comment: "Placeholder"),
                fieldType: .textfield
            ),
            
        ]
    }
}
