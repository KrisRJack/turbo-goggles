//
//  ImageViewCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/12/22.
//

import UIKit

open class ImageViewCell: UICollectionViewCell {
    
    public let imageView: UIImageView = .build { imageView in
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray4
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        contentView.addSubviews(imageView)
        [imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
         imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ].activate()
    }
}

