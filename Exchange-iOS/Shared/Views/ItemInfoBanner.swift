//
//  ItemInfoBanner.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/13/22.
//

import UIKit

open class ItemInfoBanner: UIView {
    
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
    
    required public init(model: ItemInfoModel) {
        super.init(frame: .zero)
        setUpText(model: model)
        fill(with: stackView, considerMargins: true)
        backgroundColor = .secondarySystemBackground
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpText(model: ItemInfoModel) {
        priceLabel.text = "$\(model.price)"
        titleLabel.text = model.title
        additionalLabel.text = "\(model.size) • \(model.condition) • \(model.category)"
    }
    
}
