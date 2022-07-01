//
//  MessagingViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/28/22.
//

import UIKit

final class MessagingViewController: UIViewController {
    
    var textViewBottomAnchor: NSLayoutConstraint?
    
    private let containerView: UIView = .build { view in
        view.cornerRadius(12)
        view.backgroundColor = .secondarySystemBackground
    }
    
    let messageTextView: MessageView = .build { view in
        view.textView.tintColor = .darkThemeColor
        view.sendButton.tintColor = .darkThemeColor
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureMesssageTextView()
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
    
    private func configureMesssageTextView() {
        view.addSubviews(containerView)
        containerView.addSubviews(messageTextView)
        
        [containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
         containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
         containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         
         messageTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
         messageTextView.leftAnchor.constraint(equalTo: containerView.layoutMarginsGuide.leftAnchor),
         messageTextView.rightAnchor.constraint(equalTo: containerView.layoutMarginsGuide.rightAnchor)
        ].activate()
        
        textViewBottomAnchor = messageTextView.bottomAnchor.constraint(equalTo: containerView.layoutMarginsGuide.bottomAnchor, constant: -4)
        textViewBottomAnchor?.activate()
    }
    
}

