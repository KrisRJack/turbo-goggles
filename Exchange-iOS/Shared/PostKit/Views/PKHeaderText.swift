//
//  PKHeaderText.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/14/22.
//

import UIKit

open class PKHeaderText: UIView {
    
    struct Model {
        let header: PKHeader.Model
        let text: String?
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            header,
            descriptionLabel
        ])
        stackView.spacing = 12
        stackView.axis = .vertical
        return stackView
    }()
    
    public let header: PKHeader
    
    public let descriptionLabel: UILabel = .build { label in
        label.numberOfLines = 6
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .regular)
    }
    
    init(model: Model) {
        header = PKHeader(model: model.header)
        header.backgroundColor = .systemBackground
        descriptionLabel.text = model.text
        super.init(frame: .zero)
        setUpViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        fill(with: stackView, considerMargins: true)
    }
    
}
