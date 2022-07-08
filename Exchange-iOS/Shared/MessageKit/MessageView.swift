//
//  MessageView.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/1/22.
//

import UIKit

protocol MessageViewDelegate {
    func didTapSendButton(_ button: UIButton, text: String?)
}

final class MessageView: UIView {
    
    public var delegate: MessageViewDelegate?
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            textView,
            sendButton
        ])
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .bottom
        stackView.backgroundColor = .secondarySystemBackground
        return stackView
    }()
    
    public lazy var sendButton: UIButton = .build { button in
        let image = UIImage(
            systemName: "arrow.up.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 26)
        )
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(self.didTapSendButton(_:)), for: .touchUpInside)
    }
    
    public let textView: TextView = .build { textView in
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 18)
        textView.placeholder = "Type message here..."
        textView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .vertical)
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        fill(with: stackView)
        [sendButton.heightAnchor.constraint(equalToConstant: 37),
         sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor),
        ].activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func clearText() {
        textView.text = nil
    }
    
    @objc private func didTapSendButton(_ sender: UIButton) {
        delegate?.didTapSendButton(sender, text: textView.text)
    }
    
}

