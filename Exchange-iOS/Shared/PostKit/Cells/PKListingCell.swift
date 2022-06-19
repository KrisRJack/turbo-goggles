//
//  PKListingCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/12/22.
//

import UIKit
import FirebaseStorage

final class PKListingCell: UITableViewCell {
    
    public struct Model {
        let headerText: PKHeaderText.Model
        let infoBanner: PKInfoBanner.Model
        let photoReferences: [StorageReference]
    }
    
    private lazy var stackView: UIStackView = .build { stackView in
        stackView.spacing = .zero
        stackView.axis = .vertical
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(stackView)
        [stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
         stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ].activate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView = UIStackView()
        stackView.spacing = .zero
        stackView.axis = .vertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Model, from parentController: UIViewController) {
        let headerText = PKHeaderText(model: model.headerText)
        headerText.backgroundColor = .systemBackground
        headerText.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        let photosContainerView = UIView()
        photosContainerView.isUserInteractionEnabled = false
        photosContainerView.backgroundColor = .systemBackground
        photosContainerView.heightAnchor.constraint(equalTo: photosContainerView.widthAnchor).activate()
        addPhotosToContainerView(photosContainerView, photoRefs: model.photoReferences, parentViewController: parentController)
        
        let itemInfoBanner = PKInfoBanner(model: model.infoBanner)
        itemInfoBanner.layoutMargins = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
        
        let engagementBar = PKEngagementBar()
        engagementBar.backgroundColor = .systemBackground
        engagementBar.layoutMargins = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
        
        [headerText, photosContainerView, itemInfoBanner, engagementBar].forEach ({
            stackView.addArrangedSubview($0)
        })
    }
    
    private func addPhotosToContainerView(_ containerView: UIView, photoRefs: [StorageReference], parentViewController: UIViewController) {
        let childViewController = SquareImagePreviewViewController(imageReferences: photoRefs)
        containerView.addSubviews(childViewController.view)
        parentViewController.addChild(childViewController)
        childViewController.didMove(toParent: parentViewController)
    }
    
}
