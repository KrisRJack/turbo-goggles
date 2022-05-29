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
    
    let viewModel: NewListingViewModel
    var navigationDelegate: NewListingNavigationDelegate?
    let listingPhotosViewController: ListingPhotosViewController
    
    private lazy var toolBar: UIToolbar = .build { toolBar in
        toolBar.isTranslucent = false
        toolBar.backgroundColor = .systemBackground
        toolBar.setItems([UIBarButtonItem(customView: self.postButton)], animated: true)
    }
    
    private lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.cornerRadius(6)
        button.backgroundColor = .buttonThemeColor
        button.setTitleColor(.darkThemeColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .black)
        button.setTitle(NSLocalizedString("POST", comment: "Button"), for: .normal)
        button.addTarget(self, action: #selector(postButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init(images imageData: ReferenceArray<ListingImage>) {
        viewModel = NewListingViewModel(images: imageData)
        listingPhotosViewController = ListingPhotosViewController(images: imageData)
        super.init(nibName: nil, bundle: nil)
        listingPhotosViewController.delegate = self
        viewModel.shouldEditImages = { [weak self] indexPath, images in
            guard let self = self else { return }
            self.navigationDelegate?.goToEditImage(from: self, at: indexPath, with: images)
        }
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
        configureKeyboardObservers()
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
    
    @objc private func postButtonPressed() {
        viewModel.postButtonPressed()
    }
    
    @objc private func keyboardWillAppear() {
        tableView.contentInset.bottom = .zero
    }
    
    @objc private func keyboardWillDisappear() {
        tableView.contentInset.bottom = toolBarHeight + 8
    }
    
    private func configureKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    private func setUpNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem()
        navigationItem.backBarButtonItem?.title = "Back"
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
    
    private func setUp(pickerCell cell: UITableViewCell, with data: Form) {
        (cell as? MaterialPickerCell)?.data = data.pickerValues ?? [:]
        (cell as? MaterialPickerCell)?.subtext = data.subtitle
        (cell as? MaterialPickerCell)?.setPrimaryColor(to: .secondaryLabel)
    }
    
    private func setUp(textFieldCell cell: UITableViewCell, with data: Form) {
        (cell as? MaterialTextFieldCell)?.title = data.title
        (cell as? MaterialTextFieldCell)?.placeholder = data.placeholder
        (cell as? MaterialTextFieldCell)?.subtext = data.subtitle
        (cell as? MaterialTextFieldCell)?.setTextColor(to: .label)
        (cell as? MaterialTextFieldCell)?.setPrimaryColor(to: .lightThemeColor)
        (cell as? MaterialTextFieldCell)?.setSecondaryColor(to: .secondaryLabel)
    }
    
    private func setUp(textViewCell cell: UITableViewCell, with data: Form) {
        (cell as? MaterialTextViewCell)?.title = data.title
        (cell as? MaterialTextViewCell)?.placeholder = data.placeholder
        (cell as? MaterialTextViewCell)?.subtext = data.subtitle
        (cell as? MaterialTextViewCell)?.setTextColor(to: .label)
        (cell as? MaterialTextViewCell)?.setPrimaryColor(to: .lightThemeColor)
        (cell as? MaterialTextViewCell)?.setSecondaryColor(to: .secondaryLabel)
    }
    
    public func addObserversToViewModel(for cell: UITableViewCell, fieldType: FieldType) {
        switch fieldType {
        case .title:
            viewModel.inputListener.title = {
                (cell as? MaterialTextFieldCell)?.text
            }
        case .price:
            viewModel.inputListener.price = {
                (cell as? MaterialTextFieldCell)?.text
            }
        case .description:
            viewModel.inputListener.description = {
                (cell as? MaterialTextViewCell)?.text
            }
        case .size:
            viewModel.inputListener.size = {
                (cell as? MaterialTextFieldCell)?.text
            }
        case .tags:
            viewModel.inputListener.tags = {
                (cell as? MaterialTextFieldCell)?.text
            }
        case .condition:
            viewModel.inputListener.condition = {
                (cell as? MaterialPickerCell)?.selectedTextInComponent[0]
            }
        case .categories:
            viewModel.inputListener.category = {
                (cell as? MaterialPickerCell)?.selectedTextInComponent[0]
            }
        }
    }
    
}

// MARK: - UITableViewDataSource

extension NewListingViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return form.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        let data = form[indexPath.row]
        
        switch data.inputType {
        case .textfield:
            cell = tableView.dequeueReusableCell(withIdentifier: MaterialTextFieldCell.reuseIdentifier, for: indexPath)
            setUp(textFieldCell: cell, with: data)
        case .textView:
            cell = tableView.dequeueReusableCell(withIdentifier: MaterialTextViewCell.reuseIdentifier, for: indexPath)
            setUp(textViewCell: cell, with: data)
        case .picker:
            cell = tableView.dequeueReusableCell(withIdentifier: MaterialPickerCell.reuseIdentifier, for: indexPath)
            setUp(pickerCell: cell, with: data)
        }
        
        addObserversToViewModel(for: cell, fieldType: data.fieldType)
        return cell
        
    }
    
}

// MARK: - ListingPhotosDelegate

extension NewListingViewController: ListingPhotosDelegate {
    
    func shouldGetMedia() {
        navigationDelegate?.goToGetMedia(from: self)
    }
    
    func shouldEditImage(at indexPath: IndexPath) {
        viewModel.shouldEditImage(at: indexPath)
    }
    
}

// MARK: - Form

extension NewListingViewController {
    
    enum FieldType {
        case title
        case price
        case description
        case size
        case tags
        case condition
        case categories
    }
    
    enum InputType {
        case textfield
        case textView
        case picker
    }
    
    struct Form {
        let title: String?
        let subtitle: String?
        let placeholder: String?
        let pickerValues: [String: [String]]?
        let inputType: InputType
        let fieldType: FieldType
        
        init(title: String, subtitle: String?, placeholder: String, inputType: InputType, fieldType: FieldType) {
            self.title = title
            self.subtitle = subtitle
            self.placeholder = placeholder
            self.inputType = inputType
            self.pickerValues = nil
            self.fieldType = fieldType
        }
        
        init(pickerValues: [String: [String]], subtitle: String?, fieldType: FieldType) {
            self.title = nil
            self.subtitle = subtitle
            self.placeholder = nil
            self.inputType = .picker
            self.pickerValues = pickerValues
            self.fieldType = fieldType
        }
    }
    
    var form: [Form] {
        [
            Form(
                title: NSLocalizedString("LISTING_TITLE_HEADER", comment: "Header"),
                subtitle: nil,
                placeholder: NSLocalizedString("LISTING_TITLE_PLACEHOLDER", comment: "Placeholder"),
                inputType: .textfield,
                fieldType: .title
            ),
            
            Form(
                title: NSLocalizedString("LISTING_PRICE_HEADER", comment: "Header"),
                subtitle: nil,
                placeholder: NSLocalizedString("LISTING_PRICE_PLACEHOLDER", comment: "Placeholder"),
                inputType: .textfield,
                fieldType: .price
            ),
            
            Form(
                title: NSLocalizedString("LISTING_DESCRIPTION_HEADER", comment: "Header"),
                subtitle: NSLocalizedString("LISTING_DESCRIPTION_TEXT", comment: "General"),
                placeholder: NSLocalizedString("LISTING_DESCRIPTION_PLACEHOLDER", comment: "Placeholder"),
                inputType: .textView,
                fieldType: .description
            ),
            
            Form(
                title: NSLocalizedString("LISTING_SIZE_HEADER", comment: "Header"),
                subtitle: NSLocalizedString("LISTING_SIZE_TEXT", comment: "Placeholder"),
                placeholder: NSLocalizedString("LISTING_SIZE_PLACEHOLDER", comment: "Placeholder"),
                inputType: .textfield,
                fieldType: .size
            ),
            
            Form(
                title: NSLocalizedString("LISTING_TAG_HEADER", comment: "Header"),
                subtitle: NSLocalizedString("LISTING_TAG_TEXT", comment: "Placeholder"),
                placeholder: NSLocalizedString("LISTING_TAG_PLACEHOLDER", comment: "Placeholder"),
                inputType: .textfield,
                fieldType: .tags
            ),
            
            Form(
                pickerValues: ["Select Condition:":conditions],
                subtitle: NSLocalizedString("LISTING_CONDITION_PICKER_TEXT", comment: "General"),
                fieldType: .condition
            ),
            
            Form(
                pickerValues: ["Select Categories:":categories],
                subtitle: NSLocalizedString("LISTING_CATEGORY_PICKER_TEXT", comment: "General"),
                fieldType: .categories
            ),
            
        ]
    }
}
