//
//  OnboardTableViewCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/21/22.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

protocol OnboardTableViewCellDelegate {
    func didTapDoneButton()
}

final class OnboardTableViewCell: UITableViewCell {
    
    public var firstNameText: String? { firstNameTextField.text }
    public var lastNameText: String? { lastNameTextField.text }
    public var usernameText: String? { usernameTextField.text }
    public var dobText: String? { dobTextField.text }
    
    let primaryStackView: UIStackView = .build { stackView in
        stackView.spacing = 15
        stackView.axis = .vertical
        stackView.alignment = .leading
    }
    
    let secondaryStackView: UIStackView = .build { stackView in
        stackView.spacing = 15
        stackView.axis = .horizontal
    }
    
    let headerLabel: UILabel = .build { label in
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .systemFont(ofSize: 40, weight: .heavy)
        label.text = NSLocalizedString("ONBOARD_HEADER", comment: "Header")
    }
    
    let firstNameTextField: MDCOutlinedTextField = .build { textField in
        textField.textContentType = .givenName
        textField.keyboardType = .namePhonePad
        textField.label.text = NSLocalizedString("FIRST_NAME_HEADER", comment: "Header")
        textField.placeholder = NSLocalizedString("FIRST_NAME_PLACEHOLDER", comment: "Placeholder")
    }
    
    let lastNameTextField: MDCOutlinedTextField = .build { textField in
        textField.keyboardType = .namePhonePad
        textField.textContentType = .familyName
        textField.label.text =  NSLocalizedString("LAST_NAME_HEADER", comment: "Header")
        textField.placeholder = NSLocalizedString("LAST_NAME_PLACEHOLDER", comment: "Placeholder")
    }
    
    let usernameTextField: MDCOutlinedTextField = .build { textField in
        textField.keyboardType = .default
        textField.textContentType = .username
        textField.label.text =  NSLocalizedString("USER_NAME_HEADER", comment: "Header")
        textField.placeholder = NSLocalizedString("USER_NAME_PLACEHOLDER", comment: "Placeholder")
    }
    
    lazy var dobTextField: MDCOutlinedTextField = .build { textField in
        textField.delegate = self
        textField.keyboardType = .default
        textField.textContentType = .dateTime
        textField.inputView = self.datePicker
        textField.label.text =  NSLocalizedString("DOB_HEADER", comment: "Header")
        textField.placeholder = NSLocalizedString("DOB_PLACEHOLDER", comment: "Placeholder")
    }
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.cornerRadius(10)
        button.backgroundColor = .darkThemeColor
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        button.setTitle(NSLocalizedString("DONE", comment: "Button"), for: .normal)
        return button
    }()
    
    lazy var datePicker: UIDatePicker = .build { [weak self] datePicker in
        guard let self = self else { return }
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        datePicker.addTarget(self, action: #selector(self.updateTextFieldWithDate(_:)), for: .valueChanged)
    }
    
    public var delegate: OnboardTableViewCellDelegate?
    
    init() {
        super.init(style: .default, reuseIdentifier: LoginTableViewCell.reuseIdentifier)
        backgroundColor = .clear
        addTargets()
        addSubviews()
        setCustomSpacing()
        configureConstraints()
        designTextFields(firstNameTextField, lastNameTextField, usernameTextField, dobTextField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTargets() {
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        contentView.addSubview(primaryStackView)
        primaryStackView.addArrangedSubview(headerLabel)
        primaryStackView.addArrangedSubview(secondaryStackView)
        secondaryStackView.addArrangedSubview(firstNameTextField)
        secondaryStackView.addArrangedSubview(lastNameTextField)
        primaryStackView.addArrangedSubview(usernameTextField)
        primaryStackView.addArrangedSubview(dobTextField)
        primaryStackView.addArrangedSubview(doneButton)
    }
    
    private func setCustomSpacing() {
        primaryStackView.setCustomSpacing(20, after: headerLabel)
        primaryStackView.setCustomSpacing(20, after: dobTextField)
    }
    
    private func configureConstraints() {
        contentView.fill(with: primaryStackView, considerMargins: true)
        [firstNameTextField.widthAnchor.constraint(equalToConstant: 1000),
         lastNameTextField.widthAnchor.constraint(equalTo: firstNameTextField.widthAnchor),
         usernameTextField.centerXAnchor.constraint(equalTo: primaryStackView.centerXAnchor),
         dobTextField.centerXAnchor.constraint(equalTo: primaryStackView.centerXAnchor),
         doneButton.heightAnchor.constraint(equalToConstant: 55),
         doneButton.widthAnchor.constraint(equalTo: primaryStackView.widthAnchor),
        ].activate()
    }
    
    private func designTextFields(_ textfields: MDCOutlinedTextField...) {
        textfields.forEach({
            $0.backgroundColor = .clear
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
    
    @objc private func doneTapped() {
        delegate?.didTapDoneButton()
    }
    
    @objc private func updateTextFieldWithDate(_ sender: Any?) {
        let picker = self.dobTextField.inputView as? UIDatePicker
        if let date = picker?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = .dateOfBirthFormat
            self.dobTextField.text = formatter.string(from: date)
        }
    }
    
}


extension OnboardTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField !== dobTextField { return }
        let picker = self.dobTextField.inputView as? UIDatePicker
        if let date = picker?.date {
            let formatter = DateFormatter()
            formatter.dateFormat = .dateOfBirthFormat
            self.dobTextField.text = "\(formatter.string(from: date))"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField === dobTextField ? false : true
    }
    
}
