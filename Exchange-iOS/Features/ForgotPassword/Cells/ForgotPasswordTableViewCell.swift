//
//  ForgotPasswordTableViewCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

protocol ForgotPasswordTableViewCellDelegate {
    func didTapSendEmailButton()
}

final class ForgotPasswordTableViewCell: UITableViewCell {
    
    public var emailText: String? { emailTextField.text }
    
    private let primaryStackView: UIStackView = .build { stackView in
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.alignment = .leading
    }
    
    private let primaryLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.text = "Reset Password"
        label.textColor = .black
        label.font = .systemFont(ofSize: 32, weight: .heavy)
    }
    
    private let secondaryLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18)
        label.text = NSLocalizedString("RESET_PASSWORD_SUBHEADER", comment: "General")
    }
    
    private let emailTextField: MDCOutlinedTextField = .build { textField in
        textField.backgroundColor = .clear
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.textContentType = .emailAddress
        textField.label.text = NSLocalizedString("EMAIL_HEADER", comment: "Header")
        textField.placeholder = NSLocalizedString("EMAIL_PLACEHOLDER", comment: "Placeholder")
    }
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.cornerRadius(10)
        button.backgroundColor = .darkThemeColor
        button.setTitle("Send Email", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        return button
    }()
    
    public var delegate: ForgotPasswordTableViewCellDelegate?
    
    init() {
        super.init(style: .default, reuseIdentifier: ForgotPasswordTableViewCell.reuseIdentifier)
        backgroundColor = .clear
        addTargets()
        addSubviews()
        setCustomSpacing()
        configureConstraints()
        designTextFields(emailTextField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addTargets() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        primaryStackView.addArrangedSubview(primaryLabel)
        primaryStackView.addArrangedSubview(secondaryLabel)
        primaryStackView.addArrangedSubview(emailTextField)
        primaryStackView.addArrangedSubview(doneButton)
    }
    
    private func setCustomSpacing() {
        primaryStackView.setCustomSpacing(8, after: primaryLabel)
    }
    
    private func configureConstraints() {
        contentView.fill(with: primaryStackView, considerMargins: true)
        [emailTextField.centerXAnchor.constraint(equalTo: primaryStackView.centerXAnchor),
         doneButton.heightAnchor.constraint(equalToConstant: 55),
         doneButton.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor),
        ].activate()
    }
    
    private func designTextFields(_ textfields: MDCOutlinedTextField...) {
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
    private func doneButtonTapped() {
        delegate?.didTapSendEmailButton()
    }
}

