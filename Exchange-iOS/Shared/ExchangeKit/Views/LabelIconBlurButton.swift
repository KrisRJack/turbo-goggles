//
//  LabelIconBlurView.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/20/22.
//

import UIKit

open class LabelIconBlurButton: BlurView {
    
    open override var tintColor: UIColor! {
        willSet {
            imageView.tintColor = newValue
            titleLabel.textColor = newValue
        }
    }
    
    var titleLabel: UILabel = .build()
    var imageView: UIImageView = .build()
    private let button: UIButton = .build()
    private let containerView: UIView = .build { view in
        view.backgroundColor = .clear
    }
    
    required public init(style: UIBlurEffect.Style) {
        super.init(style: style)
        configureConstraints()
        configureCaptureButtonTapAnimation()
        layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button.addTarget(target, action: action, for: controlEvents)
    }
    
    private func configureConstraints() {
        addSubviews(containerView, button)
        containerView.addSubviews(titleLabel, imageView)
        bringSubviewToFront(button)
        [containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
         containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
         containerView.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor),
         containerView.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
         
         titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
         titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
         titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
         
         imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
         imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
         imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
         imageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
         
         button.topAnchor.constraint(equalTo: topAnchor),
         button.centerXAnchor.constraint(equalTo: centerXAnchor),
         button.centerYAnchor.constraint(equalTo: centerYAnchor),
         button.leadingAnchor.constraint(equalTo: leadingAnchor),
        ].activate()
    }
    
    private func configureCaptureButtonTapAnimation() {
        button.addTarget(self, action: #selector(captureButtonTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(captureButtonTouchDown), for: .touchDragEnter)
        button.addTarget(self, action: #selector(captureButtonTouchRelease), for: .touchUpInside)
        button.addTarget(self, action: #selector(captureButtonTouchRelease), for: .touchDragExit)
    }
    
    @objc private func captureButtonTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.imageView.alpha = 0.2
            self.titleLabel.alpha = 0.2
        }
    }
    
    @objc private func captureButtonTouchRelease() {
        UIView.animate(withDuration: 0.1) {
            self.imageView.alpha = 1
            self.titleLabel.alpha = 1
        }
    }
}
