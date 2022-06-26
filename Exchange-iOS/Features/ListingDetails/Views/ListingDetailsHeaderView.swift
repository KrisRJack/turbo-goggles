//
//  ListingDetailsHeaderView.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/22/22.
//

import UIKit

final class ListingDetailsHeaderView: UIView {
    
    public typealias Model = (
        header: PKHeader.Model,
        formattedPrice: String,
        title: String,
        description: String?,
        size: String?,
        condition: String?,
        category: String?,
        tags: [String]?
    )
    
    public lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            header,
            priceLabel,
            titleLabel,
            descriptionLabel,
            miscellaneousLabel,
            tagsContainerView,
            engagementBar
        ])
        stackView.spacing = 20
        stackView.axis = .vertical
        return stackView
    }()
    
    public let header: PKHeader = .build { view in
        view.backgroundColor = .systemBackground
    }
    
    public let priceLabel: UILabel = .build { label in
        label.textColor = .label
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 18)
    }
    
    public let titleLabel: UILabel = .build { label in
        label.textColor = .label
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    public let descriptionLabel: UILabel = .build { label in
        label.textColor = .label
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 18)
    }
    
    public let miscellaneousLabel: UILabel = .build { label in
        label.textColor = .label
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 14)
    }
    
    public let tagsContainerView: UIView = .build()
    public var tagsViewController: TagsViewController?
    
    public let tagsLabel: UILabel = .build { label in
        label.textColor = .lightThemeColor
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 14, weight: .heavy)
    }
    
    public let engagementBar: PKEngagementBar = .build { engagementBar in
        engagementBar.layoutMargins = .zero
    }
    
    init() {
        super.init(frame: .zero)
        configureViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Model, parentViewController: UIViewController) {
        header.configure(with: model.header)
        priceLabel.text = model.formattedPrice
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        
        // Configure tags collection view
        addTags(model.tags ?? [], to: parentViewController)
        if let tags = model.tags, tags.isEmpty { stackView.removeArrangedSubview(tagsContainerView) }
        
        /// Using `KeyValuePairs` to keep custom order of Collection
        let additionalInfo: KeyValuePairs = [
            "Size" : model.size,
            "Condition" : model.condition,
            "Category" : model.category
        ]
        
        let itemInfo: [NSAttributedString?] = additionalInfo.map ({ key, value in
            guard let value = value else { return nil }
            return NSMutableAttributedString()
                .append("\(key): ", withFont: .systemFont(ofSize: miscellaneousLabel.font.pointSize, weight: .bold))
                .append("\(value)", withFont: .systemFont(ofSize: miscellaneousLabel.font.pointSize, weight: .regular))
        })
        
        miscellaneousLabel.attributedText = itemInfo.compactMap({ $0 }).joined(separator: " • ")
    }
    
    private func configureViews() {
        addCustomSpacing()
        fill(with: stackView, considerMargins: true)
        tagsContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).activate()
    }
    
    private func addCustomSpacing() {
        stackView.setCustomSpacing(.zero, after: priceLabel)
    }
    
    private func addTags(_ tags: [String], to parentViewController: UIViewController) {
        tagsViewController = .init(tags: tags)
        tagsContainerView.addSubviews(tagsViewController!.view)
        parentViewController.addChild(tagsViewController!)
        tagsViewController!.didMove(toParent: parentViewController)
    }
    
}
