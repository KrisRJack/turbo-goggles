//
//  MessagingViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/28/22.
//

import UIKit

protocol MessagingNavigationDelegate {
    func presentError(from viewController: MessagingViewController, withMessage message: String)
}

final class MessagingViewController: UIViewController {
    
    public var navigationDelegate: MessagingNavigationDelegate?
    
    private var viewModel: MessagingViewModel!
    private var textViewBottomAnchor: NSLayoutConstraint?
    
    private let containerView: UIView = .build { view in
        view.cornerRadius(12)
        view.backgroundColor = .secondarySystemBackground
    }
    
    private lazy var messageTextView: MKComposeView = .build { view in
        view.delegate = self
        view.textView.tintColor = .darkThemeColor
        view.sendButton.tintColor = .darkThemeColor
    }
    
    private lazy var tableView: UITableView = .build { tableView in
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(MKPrimaryMessageCell.self, forCellReuseIdentifier: MKPrimaryMessageCell.reuseIdentifier)
        tableView.register(MKSecondaryMessageCell.self, forCellReuseIdentifier: MKSecondaryMessageCell.reuseIdentifier)
    }
    
    init(listing: Listing) {
        viewModel = MessagingViewModel(with: listing)
        super.init(nibName: nil, bundle: nil)
        
        viewModel.error = { [weak self] message in
            guard let self = self else { return }
            self.navigationDelegate?.presentError(from: self, withMessage: message)
        }
    
        viewModel.reloadData = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
        
        viewModel.didSendMessage = { [weak self] in
            guard let self = self else { return }
            self.messageTextView.clearText()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageTextView()
        viewModel.viewDidLoad()
        title = viewModel.navigationTitle
        view.backgroundColor = .systemBackground
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObservers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageTextView.textView.becomeFirstResponder()
    }
    
    // MARK: - Objective-C Function
    
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let time = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        UIView.animate(withDuration: time) { [weak self] in
            guard let self = self else { return }
            self.textViewBottomAnchor?.constant = -(keyboardFrame.height - self.view.layoutMargins.bottom + 4)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let time = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        let _ = keyboardSize.cgRectValue
        UIView.animate(withDuration: time) { [weak self] in
            guard let self = self else { return }
            self.textViewBottomAnchor?.constant = -4
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - PRIVATE
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func configureMessageTextView() {
        view.addSubviews(tableView, containerView)
        containerView.addSubviews(messageTextView)
        
        [containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
         containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
         containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
         messageTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
         messageTextView.leftAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leftAnchor),
         messageTextView.rightAnchor.constraint(equalTo: containerView.layoutMarginsGuide.rightAnchor),
         
         tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         tableView.bottomAnchor.constraint(equalTo: containerView.topAnchor),
         tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        ].activate()
        
        textViewBottomAnchor = messageTextView.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor, constant: -4)
        textViewBottomAnchor?.activate()
    }
    
}

// MARK: - UITableViewDataSource

extension MessagingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.message(forItemAtIndex: indexPath.item)
        if message.isSentByCurrentUser {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: MKPrimaryMessageCell.reuseIdentifier, for: indexPath)
            (cell as? MKPrimaryMessageCell)?.configure(with: MKPrimaryMessageCell.Model(
                text: message.text,
                date: message.date
            ))
            return cell
            
        } else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: MKSecondaryMessageCell.reuseIdentifier, for: indexPath)
            (cell as? MKSecondaryMessageCell)?.configure(with: MKSecondaryMessageCell.Model(
                text: message.text,
                date: message.date,
                imageReference: StorageService.reference(.users).child(message.fromUserID + "." + .jpegExtensionFormat)
            ))
            return cell
            
        }
    }
    
}

// MARK: - MKComposeViewDelegate

extension MessagingViewController: MKComposeViewDelegate {
    
    func didTapSendButton(_ button: UIButton, text: String?) {
        viewModel.didTapSend(text: text)
    }
    
}
