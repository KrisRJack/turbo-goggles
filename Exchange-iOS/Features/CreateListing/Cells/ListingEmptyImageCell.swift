//
//  ListingEmptyImageCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/22/22.
//

import UIKit

final class ListingEmptyImageCell: UICollectionViewCell {
    
    private let containerView: UIView = .build { view in
        view.cornerRadius(6)
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()
    
    private let iconImageView: UIImageView = .build { imageView in
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(
            systemName: "photo.on.rectangle.angled",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 22)
        )
    }
    
    private let label: UILabel = .build { label in
        label.text = "Add Images"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 17)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        contentView.addSubviews(containerView, stackView)
        [containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
         containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
         stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ].activate()
    }
    
}

