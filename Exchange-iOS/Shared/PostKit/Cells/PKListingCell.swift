//
//  PKListingCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/12/22.
//

import UIKit
import FirebaseStorage

final class PKListingCell: UITableViewCell {
    
    public typealias Model = (headerText: PKHeaderText.Model, infoBanner: PKInfoBanner.Model, photoReferences: [StorageReference])
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerText,
            photosContainerView,
            itemInfoBanner,
            engagementBar
        ])
        stackView.spacing = .zero
        stackView.axis = .vertical
        return stackView
    }()
    
    private let headerText: PKHeaderText = .build { headerText in
        headerText.backgroundColor = .systemBackground
        headerText.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    private let photosContainerView: UIView = .build { view in
        view.isUserInteractionEnabled = false
        view.backgroundColor = .systemBackground
    }
    
    private let itemInfoBanner: PKInfoBanner = .build { itemInfoBanner in
        itemInfoBanner.layoutMargins = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
    }
    
    private let engagementBar: PKEngagementBar = .build { engagementBar in
        engagementBar.backgroundColor = .systemBackground
        engagementBar.layoutMargins = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
    }
    
    private let imagePreviewViewController = SquareImagePreviewViewController()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(stackView)
        photosContainerView.addSubviews(imagePreviewViewController.view)
        [stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
         stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
         photosContainerView.heightAnchor.constraint(equalTo: photosContainerView.widthAnchor)
        ].activate()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerText.prepareForReuse()
        itemInfoBanner.prepareForReuse()
        imagePreviewViewController.removeFromParent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: Model) {
        headerText.configure(with: model.headerText)
        itemInfoBanner.configure(with: model.infoBanner)
        imagePreviewViewController.setImages(with: model.photoReferences)
    }
    
    public func setParentViewController(to parentViewController: UIViewController) {
        parentViewController.addChild(imagePreviewViewController)
        imagePreviewViewController.didMove(toParent: parentViewController)
    }
    
}
