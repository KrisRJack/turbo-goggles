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
    
    private let buttonHeight: CGFloat = 50
    private lazy var toolBarHeight: CGFloat = buttonHeight + 40
    
    var images: ReferenceArray<ListingImage>
    let listingPhotosViewController: ListingPhotosViewController
    var navigationDelegate: NewListingNavigationDelegate?
    
    private lazy var toolBar: UIToolbar = .build { toolBar in
        toolBar.isTranslucent = false
        toolBar.backgroundColor = .systemBackground
        toolBar.setItems([UIBarButtonItem(customView: self.postButton)], animated: true)
    }
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.cornerRadius(6)
        button.backgroundColor = .buttonThemeColor
        button.setTitleColor(.darkThemeColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .black)
        button.setTitle(NSLocalizedString("POST", comment: "Button"), for: .normal)
        return button
    }()
    
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
        configureTableView()
        configurePostButton()
        configureTableViewHeader()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    @objc private func keyboardWillAppear(notification: Notification) {
        tableView.contentInset.bottom = .zero
    }
    
    @objc private func keyboardWillDisappear() {
        tableView.contentInset.bottom = toolBarHeight + 8
    }
    
    private func setUpNavigationBar() {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.rightBarButtonItem = .init(
            title: "Post",
            style: .done,
            target: self,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .darkThemeColor
        navigationController?.topViewController?.title = "New Listing"
    }
    
    private func configureTableViewHeader() {
        tableView.tableHeaderView = UIView()
        tableView.tableHeaderView?.addSubviews(listingPhotosViewController.view)
        tableView.tableHeaderView?.frame.size.height = 250
        addChild(listingPhotosViewController)
        listingPhotosViewController.didMove(toParent: self)
    }
    
    private func configurePostButton() {
        view.addSubviews(toolBar)
        NSLayoutConstraint.activate([
            toolBar.heightAnchor.constraint(equalToConstant: toolBarHeight),
            postButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func configureTableView() {
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset.bottom = toolBarHeight + 8
        tableView.register(MaterialPickerCell.self, forCellReuseIdentifier: MaterialPickerCell.reuseIdentifier)
        tableView.register(MaterialTextViewCell.self, forCellReuseIdentifier: MaterialTextViewCell.reuseIdentifier)
        tableView.register(MaterialTextFieldCell.self, forCellReuseIdentifier: MaterialTextFieldCell.reuseIdentifier)
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
            
        case .picker:
            let cell = tableView.dequeueReusableCell(withIdentifier: MaterialPickerCell.reuseIdentifier, for: indexPath)
            (cell as? MaterialPickerCell)?.data = data.pickerValues ?? [:]
            (cell as? MaterialPickerCell)?.subtext = data.subtitle
            (cell as? MaterialPickerCell)?.setPrimaryColor(to: .secondaryLabel)
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
        case picker
    }
    
    struct Form {
        let title: String?
        let subtitle: String?
        let placeholder: String?
        let pickerValues: [String: [String]]?
        let fieldType: FieldType
        
        init(title: String, subtitle: String?, placeholder: String, fieldType: FieldType) {
            self.title = title
            self.subtitle = subtitle
            self.placeholder = placeholder
            self.fieldType = fieldType
            self.pickerValues = nil
        }
        
        init(pickerValues: [String: [String]], subtitle: String?) {
            self.title = nil
            self.subtitle = subtitle
            self.placeholder = nil
            self.fieldType = .picker
            self.pickerValues = pickerValues
        }
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
            
            Form(
                pickerValues: ["Select Condition:":conditions],
                subtitle: NSLocalizedString("LISTING_CONDITION_PICKER_TEXT", comment: "General")
            ),
            
            Form(
                pickerValues: ["Select Categories:":categories],
                subtitle: NSLocalizedString("LISTING_CATEGORY_PICKER_TEXT", comment: "General")
            ),
            
        ]
    }
}
