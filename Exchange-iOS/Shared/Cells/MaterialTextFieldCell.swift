//
//  MaterialTextFieldCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/14/22.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

final class MaterialTextFieldCell: UITableViewCell {
    
    public var title: String? {
        get { materialTextField.label.text }
        set { materialTextField.label.text = newValue }
    }
    
    public var placeholder: String? {
        get { materialTextField.placeholder }
        set { materialTextField.placeholder = newValue }
    }
    
    public var subtext: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    public var text: String? {
        return materialTextField.text
    }
    
    private lazy var stackView: UIStackView = .build { stackView in
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.addArrangedSubview(self.materialTextField)
        stackView.addArrangedSubview(self.label)
    }
    
    private let label: UILabel = .build { label in
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
    }
    
    private let materialTextField: MDCOutlinedTextField = .build { textField in
        textField.preferredContainerHeight = 50
        textField.leadingAssistiveLabel.font = .systemFont(ofSize: 12)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        [stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
         stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
         stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ].activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTextColor(to color: UIColor) {
        materialTextField.setTextColor(color, for: .editing)
    }
    
    public func setPrimaryColor(to color: UIColor) {
        materialTextField.setOutlineColor(color, for: .editing)
        materialTextField.setFloatingLabelColor(color, for: .editing)
    }
    
    public func setSecondaryColor(to color: UIColor) {
        label.textColor = color
        materialTextField.setOutlineColor(color, for: .normal)
        materialTextField.setNormalLabelColor(color, for: .normal)
        materialTextField.setFloatingLabelColor(color, for: .normal)
    }
    
}
