//
//  InboxView.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 8/26/22.
//

import UIKit
import FirebaseStorageUI

final class InboxView: UIView {
    
    private var imageHeight: CGFloat { 50 }
    
    private lazy var primaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageHeight.halfOf
        imageView.backgroundColor = .secondarySystemBackground
        imageView.image = UIImage(systemName: "person.crop.circle")
        return imageView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            displayNameLabel,
            usernameLabel,
            previewLabel
        ])
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.setCustomSpacing(6, after: usernameLabel)
        return stackView
    }()
    
    private let dateLabel: UILabel = .build { label in
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .tertiaryLabel
        label.font = .preferredFont(forTextStyle: .callout)
    }
    
    private let displayNameLabel: UILabel = .build { label in
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .headline)
    }
    
    private let usernameLabel: UILabel = .build { label in
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .subheadline)
    }
    
    private let previewLabel: UILabel = .build { label in
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .callout)
    }
    
    init() {
        super.init(frame: .zero)
        addSubviews(primaryImageView, infoStackView, dateLabel)
        
        [primaryImageView.topAnchor.constraint(equalTo: topAnchor),
         primaryImageView.leftAnchor.constraint(equalTo: leftAnchor),
         primaryImageView.widthAnchor.constraint(equalToConstant: imageHeight),
         primaryImageView.heightAnchor.constraint(equalToConstant: imageHeight),
         primaryImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
         
         infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
         infoStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
         infoStackView.leftAnchor.constraint(equalTo: primaryImageView.rightAnchor, constant: 8),
         
         dateLabel.rightAnchor.constraint(equalTo: rightAnchor),
         dateLabel.topAnchor.constraint(equalTo: infoStackView.topAnchor),
         dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
         dateLabel.leftAnchor.constraint(equalTo: infoStackView.rightAnchor, constant: 2),
        ].activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Channel) {
        model.lastMessage.map({
            previewLabel.text = $0.text
            usernameLabel.text = "@\($0.fromUsername)"
            displayNameLabel.text = $0.fromDisplayName
            dateLabel.text = $0.date.getElapsedInterval()
            if let imageRef = model.imageReference {
                let placeholderImage = UIImage(systemName: "person.crop.circle")
                primaryImageView.sd_setImage(with: imageRef, placeholderImage: placeholderImage)
            }
        })
    }
    
}
