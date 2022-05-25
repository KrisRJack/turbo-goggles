//
//  MaterialTextFieldCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/14/22.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

final class MaterialTextFieldCell: UITableViewCell {
    
    public let materialTextField: MDCOutlinedTextField = .build()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(materialTextField)
        [materialTextField.topAnchor.constraint(equalTo: contentView.topAnchor),
         materialTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         materialTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         materialTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ].activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
