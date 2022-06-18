//
//  ListingImageCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/21/22.
//

import UIKit

final class ListingImageCell: UICollectionViewCell {
    
    public var deleteButtonPressed: ((_ indexPath: IndexPath) -> Void)?
    private let deleteButtonHeight: CGFloat = 25
    
    private lazy var deleteButton: BlurButton = {
        let button = BlurButton()
        button.cornerRadius(deleteButtonHeight.halfOf)
        button.tintColor = .white
        button.clipsToBounds = true
        button.setImage(UIImage(
            systemName: "xmark",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
        ), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        return button
    }()
    
    private let dragButton: BlurButton = {
        let button = BlurButton()
        button.cornerRadius(5)
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        button.setTitle("Hold & Drag", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        return button
    }()
    
    private let imageView: UIImageView = .build { imageView in
        imageView.cornerRadius(8)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
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
    
    public func setImage(data: Data) {
        imageView.image = UIImage(data: data)
    }
    
    private func configureConstraints() {
        contentView.addSubviews(imageView, deleteButton, dragButton)
        [imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
         imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         
         deleteButton.widthAnchor.constraint(equalToConstant: deleteButtonHeight),
         deleteButton.heightAnchor.constraint(equalToConstant: deleteButtonHeight),
         deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
         deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
         
         dragButton.widthAnchor.constraint(equalToConstant: 87),
         dragButton.heightAnchor.constraint(equalToConstant: 25),
         dragButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
         dragButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ].activate()
    }
    
    @objc private func deletePressed() {
        guard let indexPath = indexPath else { return }
        deleteButtonPressed?(indexPath)
    }
    
}
