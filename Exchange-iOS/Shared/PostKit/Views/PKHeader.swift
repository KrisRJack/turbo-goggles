//
//  PKHeader.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/14/22.
//

import UIKit
import Firebase
import FirebaseStorageUI

open class PKHeader: UIView {
    
    struct Model {
        let displayName: String
        let username: String
        let datePosted: Date
        let imageReference: StorageReference
    }
    
    private let imageSize: CGFloat = 42
    public var didTapMoreButton: ((_ sender: UIButton) -> Void)?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            labelStackView,
            moreButton
        ])
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            primaryLabel,
            secondaryLabel
        ])
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    public lazy var imageView: UIImageView = .build { imageView in
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = self.imageSize.halfOf
        imageView.backgroundColor = .secondarySystemBackground
    }
    
    public let primaryLabel: UILabel = .build { label in
        label.textColor = .label
        label.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    public let secondaryLabel: UILabel = .build { label in
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .regular)
    }
    
    public lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .secondaryLabel
        button.contentHorizontalAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 18, weight: .semibold), forImageIn: .normal)
        button.addTarget(self, action: #selector(didTapMore(_:)), for: .touchUpInside)
        return button
    }()
    
    init(model: Model) {
        super.init(frame: .zero)
        setUpViews()
        setUp(model: model)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        fill(with: stackView, considerMargins: false)
        [imageView.heightAnchor.constraint(equalToConstant: imageSize),
         imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
         moreButton.heightAnchor.constraint(equalTo: stackView.heightAnchor),
         moreButton.widthAnchor.constraint(equalTo: moreButton.heightAnchor),
        ].activate()
    }
    
    private func setUp(model: Model) {
        primaryLabel.text = model.displayName
        secondaryLabel.text = "@\(model.username) • \(model.datePosted.getElapsedInterval())"
        imageView.sd_setImage(with: model.imageReference)
    }
    
    @objc private func didTapMore(_ sender: UIButton) {
        didTapMoreButton?(sender)
    }
    
}
