//
//  SignUpTableViewCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/13/22.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

protocol SignUpTableViewCellDelegate {
    func didTapLogInButton()
    func didTapSignUpButton()
}

final class SignUpTableViewCell: UITableViewCell {
    
    public var emailText: String? { emailTextField.text }
    public var passwordText: String? { passwordTextField.text }
    
    let primaryStackView: UIStackView = .build { stackView in
        stackView.spacing = 15
        stackView.axis = .vertical
        stackView.alignment = .leading
    }
    
    let secondaryStackView: UIStackView = .build { stackView in
        stackView.spacing = 5
        stackView.axis = .horizontal
    }
    
    let signUpLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.text = "Sign Up"
        label.textColor = .black
        label.font = .systemFont(ofSize: 40, weight: .heavy)
    }
    
    let orLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.text = "Or"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18)
    }
    
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.darkThemeColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return button
    }()
    
    let emailTextField: MDCOutlinedTextField = .build { textField in
        textField.backgroundColor = .clear
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.textContentType = .emailAddress
        textField.label.text = NSLocalizedString("EMAIL_HEADER", comment: "Header")
        textField.placeholder = NSLocalizedString("NEW_EMAIL_PLACEHOLDER", comment: "Placeholder")
    }
    
    let passwordTextField: MDCOutlinedTextField = .build { textField in
        textField.backgroundColor = .clear
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.textContentType = .password
        textField.label.text =  NSLocalizedString("PASSWORD_HEADER", comment: "Header")
        textField.placeholder = NSLocalizedString("NEW_PASSWORD_PLACEHOLDER", comment: "Placeholder")
    }
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.cornerRadius(10)
        button.backgroundColor = .darkThemeColor
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        return button
    }()
    
    let legalLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
        label.text = NSLocalizedString("LEGAL_TEXT", comment: "General")
    }
    
    public var delegate: SignUpTableViewCellDelegate?
    
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
    }
    
    private func addSubviews() {
        contentView.addSubview(primaryStackView)
        primaryStackView.addArrangedSubview(signUpLabel)
        primaryStackView.addArrangedSubview(secondaryStackView)
        secondaryStackView.addArrangedSubview(orLabel)
        secondaryStackView.addArrangedSubview(logInButton)
        primaryStackView.addArrangedSubview(emailTextField)
        primaryStackView.addArrangedSubview(passwordTextField)
        primaryStackView.addArrangedSubview(signUpButton)
        primaryStackView.addArrangedSubview(legalLabel)
    }
    
    private func setCustomSpacing() {
        primaryStackView.setCustomSpacing(.zero, after: signUpLabel)
        primaryStackView.setCustomSpacing(20, after: secondaryStackView)
        primaryStackView.setCustomSpacing(20, after: passwordTextField)
    }
    
    private func configureConstraints() {
        contentView.fill(with: primaryStackView, considerMargins: true)
        [emailTextField.centerXAnchor.constraint(equalTo: primaryStackView.centerXAnchor),
         passwordTextField.centerXAnchor.constraint(equalTo: primaryStackView.centerXAnchor),
         signUpButton.heightAnchor.constraint(equalToConstant: 55),
         signUpButton.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor),
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
    
    
    @objc private func logInTapped() {
        delegate?.didTapLogInButton()
    }
    
    @objc private func signUpTapped() {
        delegate?.didTapSignUpButton()
    }
    
}
