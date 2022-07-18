//
//  MKPrimaryMessageCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/16/22.
//

import UIKit
import Firebase

final class MKPrimaryMessageCell: UITableViewCell {
    
    public typealias Model = (text: String, date: Date)
    
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
    
    public let timeLabel: UILabel = .build { label in
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12)
    }
    
    private let bubbleView: MKMessageBubbleView = .init(style: .primary)
    
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
    }
    
    public func configure(with model: Model) {
        bubbleView.label.text = model.text
        timeLabel.text = model.date.getElapsedInterval()
    }
    
    private func setUpViews() {
        contentView.addSubviews(stackView)
        [stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
         stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
         stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
         stackView.leftAnchor.constraint(greaterThanOrEqualTo: contentView.centerXAnchor, constant: -100),
         bubbleView.heightAnchor.constraint(greaterThanOrEqualToConstant: bubbleHeight),
        ].activate()
    }
    
}
