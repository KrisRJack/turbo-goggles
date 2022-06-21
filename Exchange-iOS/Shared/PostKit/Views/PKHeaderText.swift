//
//  PKHeaderText.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/14/22.
//

import UIKit

open class PKHeaderText: UIView {
    
    public typealias Model = (header: PKHeader.Model, text: String?)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            header,
            descriptionLabel
        ])
        stackView.spacing = 12
        stackView.axis = .vertical
        return stackView
    }()
    
    private let header: PKHeader = .build { header in
        header.backgroundColor = .systemBackground
    }
    
    private let descriptionLabel: UILabel = .build { label in
        label.numberOfLines = 6
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .regular)
    }
    
    init() {
        super.init(frame: .zero)
        fill(with: stackView, considerMargins: true)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Model) {
        header.configure(with: model.header)
        descriptionLabel.text = model.text
    }
    
    public func prepareForReuse() {
        header.prepareForReuse()
        descriptionLabel.text = nil
    }
    
}
