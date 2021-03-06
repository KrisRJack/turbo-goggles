//
//  ListingDetailsImageCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/26/22.
//

import UIKit
import FirebaseStorage

final class ListingDetailsImageCell: UITableViewCell {
    
    public typealias Model = (imageReference: StorageReference, description: String?)
    
    private let spacing: CGFloat = 15
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            label,
            separatorView,
            engagementBar
        ])
        stackView.spacing = spacing
        stackView.axis = .vertical
        return stackView
    }()
    
    private let containerView: UIView = .build { view in
        view.backgroundColor = .systemBackground
    }
    
    private let separatorView: UIView = .build { view in
        view.backgroundColor = .separator
    }
    
    private let label: UILabel = .build { label in
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 18)
    }
    
    private let engagementBar: PKEngagementBar = .build()
    private let scaledHeightImageView: ScaledHeightImageView = .build()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        contentView.addSubviews(containerView)
        containerView.addSubviews(scaledHeightImageView, stackView)
        [containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
         containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
         
         scaledHeightImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
         scaledHeightImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
         scaledHeightImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
         
         stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
         stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: spacing),
         stackView.topAnchor.constraint(equalTo: scaledHeightImageView.bottomAnchor, constant: spacing),
         stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -spacing),
         
         separatorView.heightAnchor.constraint(equalToConstant: 1)
        ].activate()
    }
    
    public func configure(with model: Model) {
        label.text = model.description
        DispatchQueue.main.async {
            self.scaledHeightImageView.sd_setImage(with: model.imageReference)
        }
    }
    
}
