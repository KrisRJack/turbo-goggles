//
//  MaterialTextViewCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/25/22.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextAreas

final class MaterialTextViewCell: UITableViewCell {
    
    public var title: String? {
        get { materialTextView.label.text }
        set { materialTextView.label.text = newValue }
    }
    
    public var placeholder: String? {
        get { materialTextView.placeholder }
        set { materialTextView.placeholder = newValue }
    }
    
    public var subtext: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    private lazy var stackView: UIStackView = .build { stackView in
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.addArrangedSubview(self.materialTextView)
        stackView.addArrangedSubview(self.label)
    }
    
    private let label: UILabel = .build { label in
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
    }
    
    public lazy var materialTextView: MDCOutlinedTextArea = .build { textView in
        textView.preferredContainerHeight = 150
        textView.leadingAssistiveLabel.font = .systemFont(ofSize: 12)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        [stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
         stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
         stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
         label.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -24)
        ].activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTextColor(to color: UIColor) {
        materialTextView.setTextColor(color, for: .editing)
    }
    
    public func setPrimaryColor(to color: UIColor) {
        materialTextView.setOutlineColor(.lightThemeColor, for: .editing)
        materialTextView.setFloatingLabel(.lightThemeColor, for: .editing)
    }
    
    public func setSecondaryColor(to color: UIColor) {
        label.textColor = color
        materialTextView.setNormalLabel(.secondaryLabel, for: .normal)
        materialTextView.setOutlineColor(.secondaryLabel, for: .normal)
        materialTextView.setFloatingLabel(.secondaryLabel, for: .normal)
    }
    
}
