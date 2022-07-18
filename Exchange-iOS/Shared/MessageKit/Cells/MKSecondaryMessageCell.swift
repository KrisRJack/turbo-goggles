//
//  MKSecondaryMessageCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/15/22.
//

import UIKit
import Firebase

final class MKSecondaryMessageCell: UITableViewCell {
    
    public typealias Model = (text: String, date: Date, imageReference: StorageReference)
    
    public var showImage: Bool {
        get { !profileImageView.isHidden }
        set { profileImageView.isHidden = !newValue }
    }
    
    public var showDate: Bool {
        get { !timeLabel.isHidden }
        set { timeLabel.isHidden = !newValue }
    }
    
    private var bubbleHeight: CGFloat = 42
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            bubbleView,
            timeLabel
        ])
        stackView.spacing = 12
        stackView.axis = .vertical
        return stackView
    }()
    
    public lazy var profileImageView: UIImageView = .build { imageView in
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius(self.bubbleHeight.halfOf)
        imageView.backgroundColor = .secondarySystemBackground
    }
    
    public let timeLabel: UILabel = .build { label in
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
    }
    
    private let bubbleView: MKMessageBubbleView = .init(style: .secondary)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showDate = true
        showImage = true
    }
    
    public func configure(with model: Model) {
        bubbleView.label.text = model.text
        timeLabel.text = model.date.getElapsedInterval()
        profileImageView.sd_setImage(with: model.imageReference)
    }
    
    private func setUpViews() {
        contentView.addSubviews(profileImageView, stackView)
        [stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
         stackView.rightAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor, constant: 100),
         profileImageView.heightAnchor.constraint(equalToConstant: bubbleHeight),
         profileImageView.widthAnchor.constraint(equalToConstant: bubbleHeight),
         profileImageView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
         profileImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
         profileImageView.rightAnchor.constraint(equalTo: stackView.leftAnchor, constant: -12),
         bubbleView.heightAnchor.constraint(greaterThanOrEqualToConstant: bubbleHeight),
        ].activate()
    }
    
}
