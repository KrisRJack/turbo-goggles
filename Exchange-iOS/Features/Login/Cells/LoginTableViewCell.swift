//
//  LoginTableViewCell.swift
//  Exchange
//
//  Created by Kristopher Jackson on 4/12/22.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

protocol LoginTableViewCellDelegate {
    func didTapLogInButton()
    func didTapSignUpButton()
    func didTapForgotPasswordButton()
}

final class LoginTableViewCell: UITableViewCell {
    
    public var emailText: String? { emailTextField.text }
    public var passwordText: String? { passwordTextField.text }
    
    private let primaryStackView: UIStackView = .build { stackView in
        stackView.spacing = 15
        stackView.axis = .vertical
        stackView.alignment = .leading
    }
    
    private let secondaryStackView: UIStackView = .build { stackView in
        stackView.spacing = 5
        stackView.axis = .horizontal
    }
    
    private let logInLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.text = "Log In"
        label.textColor = .black
        label.font = .systemFont(ofSize: 40, weight: .heavy)
    }
    
    private let orLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.text = "Or"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18)
    }
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Join Exchange", for: .normal)
        button.setTitleColor(.darkThemeColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    private let emailTextField: MDCOutlinedTextField = .build { textField in
        textField.backgroundColor = .clear
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.textContentType = .emailAddress
        textField.label.text = NSLocalizedString("EMAIL_HEADER", comment: "Header")
        textField.placeholder = NSLocalizedString("EMAIL_PLACEHOLDER", comment: "Placeholder")
    }
    
    private let passwordTextField: MDCOutlinedTextField = .build { textField in
        textField.backgroundColor = .clear
        textField.keyboardType = .default
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        textField.label.text =  NSLocalizedString("PASSWORD_HEADER", comment: "Header")
        textField.placeholder = NSLocalizedString("PASSWORD_PLACEHOLDER", comment: "Placeholder")
    }
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot password?", for: .normal)
        button.setTitleColor(.darkThemeColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    private let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.cornerRadius(10)
        button.backgroundColor = .darkThemeColor
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        return button
    }()
    
    public var delegate: LoginTableViewCellDelegate?
    
    init() {
        super.init(style: .default, reuseIdentifier: LoginTableViewCell.reuseIdentifier)
        backgroundColor = .clear
        addTargets()
        addSubviews()
        setCustomSpacing()
        configureConstraints()
        designTextFields([emailTextField, passwordTextField])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTargets() {
        logInButton.addTarget(self, action: #selector(logInTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        contentView.addSubview(primaryStackView)
        primaryStackView.addArrangedSubview(logInLabel)
        primaryStackView.addArrangedSubview(secondaryStackView)
        secondaryStackView.addArrangedSubview(orLabel)
        secondaryStackView.addArrangedSubview(signUpButton)
        primaryStackView.addArrangedSubview(emailTextField)
        primaryStackView.addArrangedSubview(passwordTextField)
        primaryStackView.addArrangedSubview(forgotPasswordButton)
        primaryStackView.addArrangedSubview(logInButton)
    }
    
    private func setCustomSpacing() {
        primaryStackView.setCustomSpacing(.zero, after: logInLabel)
        primaryStackView.setCustomSpacing(20, after: secondaryStackView)
        primaryStackView.setCustomSpacing(20, after: forgotPasswordButton)
    }
    
    private func configureConstraints() {
        contentView.fill(with: primaryStackView, considerMargins: true)
        [emailTextField.centerXAnchor.constraint(equalTo: primaryStackView.centerXAnchor),
         passwordTextField.centerXAnchor.constraint(equalTo: primaryStackView.centerXAnchor),
         logInButton.heightAnchor.constraint(equalToConstant: 55),
         logInButton.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor),
        ].activate()
    }
    
    private func designTextFields(_ textfields: [MDCOutlinedTextField]) {
        textfields.forEach({
            $0.setOutlineColor(.gray, for: .normal)
            $0.setOutlineColor(.darkThemeColor, for: .editing)
            $0.setTextColor(.black, for: .editing)
            $0.setNormalLabelColor(.gray, for: .normal)
            $0.setFloatingLabelColor(.gray, for: .normal)
            $0.setFloatingLabelColor(.darkThemeColor, for: .editing)
            $0.setLeadingAssistiveLabelColor(.systemRed, for: .normal)
            $0.setLeadingAssistiveLabelColor(.systemRed, for: .editing)
        })
    }
    
    @objc
    private func logInTapped() {
        delegate?.didTapLogInButton()
    }
    
    @objc
    private func signUpTapped() {
        delegate?.didTapSignUpButton()
    }
    
    @objc
    private func forgotPasswordTapped() {
        delegate?.didTapForgotPasswordButton()
    }
    
}
