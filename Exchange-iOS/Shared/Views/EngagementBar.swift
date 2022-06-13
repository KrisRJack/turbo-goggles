//
//  EngagementBar.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/12/22.
//

import UIKit

final class EngagementBar: UIView {
    
    enum ButtonType: Int {
        case like = 0
        case repost = 1
        case comment = 2
        case buySold = 3
    }
    
    public var buttonPressed: ((_ button: UIButton, _ type: ButtonType) -> Void)?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            likeButton,
            repostButton,
            commentButton
        ])
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .black
        button.tag = ButtonType.like.rawValue
        button.setImage(UIImage(
            systemName: "heart",
            withConfiguration: UIImage.SymbolConfiguration(font: self.imageFont)
        ), for: .normal)
        button.setImage(UIImage(
            systemName: "heart.fill",
            withConfiguration: UIImage.SymbolConfiguration(font: self.imageFont)
        ), for: .selected)
        button.addTarget(self, action: #selector(self.likeButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var repostButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .black
        button.tag = ButtonType.repost.rawValue
        button.setImage(UIImage(
            systemName: "arrow.triangle.2.circlepath",
            withConfiguration: UIImage.SymbolConfiguration.init(font: self.imageFont)
        ), for: .normal)
        button.addTarget(self, action: #selector(self.repostButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .black
        button.tag = ButtonType.comment.rawValue
        button.setImage(UIImage(
            systemName: "message",
            withConfiguration: UIImage.SymbolConfiguration.init(font: self.imageFont)
        ), for: .normal)
        button.addTarget(self, action: #selector(self.commentButtonTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var buySoldButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .black
        button.tag = ButtonType.buySold.rawValue
        button.setImage(UIImage(
            systemName: "bag.badge.plus",
            withConfiguration: UIImage.SymbolConfiguration(font: self.imageFont)
        ), for: .normal)
        button.addTarget(self, action: #selector(self.buySoldButtonTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private let imageFont: UIFont = .systemFont(ofSize: 20, weight: .medium)
    
    init() {
        super.init(frame: .zero)
        setUpViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        addSubviews(stackView, buySoldButton)
        [stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
         stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
         stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
         buySoldButton.widthAnchor.constraint(equalTo: buySoldButton.heightAnchor),
         buySoldButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
         buySoldButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
         buySoldButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
         buySoldButton.leadingAnchor.constraint(greaterThanOrEqualTo: stackView.trailingAnchor),
        ].activate()
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        buttonPressed?(sender, .like)
    }
    
    @objc private func repostButtonTapped(_ sender: UIButton) {
        buttonPressed?(sender, .repost)
    }
    
    @objc private func commentButtonTap(_ sender: UIButton) {
        buttonPressed?(sender, .comment)
    }
    
    @objc private func buySoldButtonTap(_ sender: UIButton) {
        buttonPressed?(sender, .buySold)
    }
    
}
