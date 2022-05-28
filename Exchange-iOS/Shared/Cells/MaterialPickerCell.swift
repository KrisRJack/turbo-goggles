//
//  MaterialPickerCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/27/22.
//

import UIKit

final class MaterialPickerCell: UITableViewCell {
    
    public var data: [String: [String]] = [:] {
        didSet { pickerView.reloadAllComponents() }
    }
    
    public var subtext: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    private lazy var stackView: UIStackView = .build { stackView in
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.addArrangedSubview(self.pickerView)
        stackView.addArrangedSubview(self.label)
    }
    
    private let label: UILabel = .build { label in
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
    }
    
    private lazy var pickerView: UIPickerView = .build { pickerView in
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.layer.borderWidth = 1
        pickerView.layer.cornerRadius = 6
        pickerView.layer.masksToBounds = true
        pickerView.layer.borderColor = UIColor.secondaryLabel.cgColor
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
    
    public func setPrimaryColor(to color: UIColor) {
        label.textColor = color
        pickerView.layer.borderColor = color.cgColor
    }
    
}

// MARK: - UIPickerViewDataSource

extension MaterialPickerCell: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let keys: [String] = Array(data.keys)
        let keyAtComponent: String = keys[component]
        return data[keyAtComponent]?.count ?? 0
    }
    
}

// MARK: - UIPickerViewDelegate

extension MaterialPickerCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let keys: [String] = Array(data.keys)
        let keyAtComponent: String = keys[component]
        guard row != 0 else { return keyAtComponent }
        return data[keyAtComponent]?[row - 1]
    }
    
}
