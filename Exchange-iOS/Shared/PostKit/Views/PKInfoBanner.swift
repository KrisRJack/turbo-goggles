//
//  PKInfoBanner.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/13/22.
//

import UIKit

open class PKInfoBanner: UIView {
    
    public typealias Model = (price: String, title: String, size: String?, condition: String?, category: String?)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            priceLabel,
            titleLabel,
            additionalLabel
        ])
        stackView.spacing = 2
        stackView.axis = .vertical
        return stackView
    }()
    
    private let priceLabel: UILabel = .build { label in
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    private let titleLabel: UILabel = .build { label in
        label.numberOfLines = 2
        label.textColor = .label
        label.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private let additionalLabel: UILabel = .build { label in
        label.numberOfLines = 2
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    public init() {
        super.init(frame: .zero)
        fill(with: stackView, considerMargins: true)
        backgroundColor = .secondarySystemBackground
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Model) {
        priceLabel.text = model.price
        titleLabel.text = model.title
        
        let additionalInfo: [String] = [
            model.size,
            model.condition,
            model.category
        ].compactMap({ $0 })
        
        additionalLabel.text = additionalInfo.joined(separator: " • ")
    }
    
    public func prepareForReuse() {
        priceLabel.text = nil
        titleLabel.text = nil
        additionalLabel.text = nil
    }
    
}
