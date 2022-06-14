//
//  PKListingCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/12/22.
//

import UIKit
import FirebaseStorage

final class PKListingCell: UITableViewCell {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            listingText,
            containerView,
            listingInfoBanner,
            engagementBar
        ])
        stackView.spacing = .zero
        stackView.axis = .vertical
        return stackView
    }()
    
    private let listingText: PKHeaderText = .build { text in
        text.backgroundColor = .systemBackground
        text.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    private let containerView: UIView = .build { view in
        view.backgroundColor = .systemBackground
    }
    
    private let listingInfoBanner: PKInfoBanner = {
        let listingInfoBanner = PKInfoBanner(model: PKInfoModel(
            price: 180,
            title: "Shoes",
            size: "9 1/2",
            condition: "Brand New",
            category: "Men's Clothing"
        ))
        listingInfoBanner.layoutMargins = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
        return listingInfoBanner
    }()
    
    private let engagementBar: PKEngagementBar = .build { engagementBar in
        engagementBar.backgroundColor = .systemBackground
        engagementBar.layoutMargins = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(stackView)
        [containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
         stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
         stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ].activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addPhotos(_ photoRefs: [StorageReference], to parentViewController: UIViewController) {
        let childViewController = SquareImagePreviewViewController(imageReferences: photoRefs)
        containerView.addSubviews(childViewController.view)
        parentViewController.addChild(childViewController)
        childViewController.didMove(toParent: parentViewController)
    }
    
}
