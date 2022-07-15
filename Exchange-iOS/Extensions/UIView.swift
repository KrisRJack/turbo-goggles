//
//  UIView.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 2/4/22.
//

import UIKit

extension UIView {
    
    static func build<T: UIView>(_ builder: ((T) -> Void)? = nil) -> T {
        let view = T()
        view.translatesAutoresizingMaskIntoConstraints = false
        builder?(view)
        return view
    }
    
    func cornerRadius(_ cornerRadius: CGFloat, corners: [UIRectCorner]? = nil) {
        guard let corners = corners else {
            layer.cornerRadius = cornerRadius
            return
        }
        
        var maskedCorners: CACornerMask = []
        
        for corner in corners {
            switch corner {
            case .topLeft:
                maskedCorners.update(with: .layerMinXMinYCorner)
            case .topRight:
                maskedCorners.update(with: .layerMaxXMinYCorner)
            case .bottomLeft:
                maskedCorners.update(with: .layerMinXMaxYCorner)
            case .bottomRight:
                maskedCorners.update(with: .layerMaxXMaxYCorner)
            default:
                continue
            }
        }
        
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
    }
    
    /// Makes the edge constraints (`topAnchor`, `bottomAnchor`, `leadingAnchor`, `trailingAnchor`) of a view equaled to the edge constraints of another view.
     /// - Parameters:
     ///   - view: The view that we are constraining the current view's edges to.
     ///   For example : `currentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true`
     ///   - padding: An equal amount of spacing between each edge of the current view  and `view`.
     ///   In a superview and subview relationship, `padding` is the equal space that surrounds the subview inside of the superview.
     func edges(equalTo view: UIView, padding: CGFloat = 0) {
         NSLayoutConstraint.activate([
             topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
             bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
             leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
             trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
         ])
     }
    
    /// Makes the edge constraints (`topAnchor`, `bottomAnchor`, `leadingAnchor`, `trailingAnchor`) of a view equaled to the layout margins of another view.
     /// - Parameters:
     ///   - view: The view that we are constraining the current view's edges to.
     ///   For example : `currentView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true`
     ///   - padding: An equal amount of spacing between each edge of the current view  and `view`.
     ///   In a superview and subview relationship, `padding` is the equal space that surrounds the subview inside of the superview.
    func edges(equalToLayoutMarginIn view: UIView, padding: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: padding),
            bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -padding),
            leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -padding)
        ])
    }
    
    /// Makes the edge constraints (`topAnchor`, `bottomAnchor`, `leadingAnchor`, `trailingAnchor`) of a view equaled to the safe area of another view.
     /// - Parameters:
     ///   - view: The view that we are constraining the current view's edges to.
     ///   For example : `currentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true`
     ///   - padding: An equal amount of spacing between each edge of the current view  and `view`.
     ///   In a superview and subview relationship, `padding` is the equal space that surrounds the subview inside of the superview.
    func edges(equalToSafeAreaIn view: UIView, padding: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ])
    }
    
     /// Makes the center x and y anchors of a view equaled to the center x and y anchors of another view.
     /// - Parameter view: The view that we're constraining the current view's center anchors to.
     /// For example : `currentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true`
     func center(equalTo view: UIView) {
         NSLayoutConstraint.activate([
             centerXAnchor.constraint(equalTo: view.centerXAnchor),
             centerYAnchor.constraint(equalTo: view.centerYAnchor)
         ])
     }
    
    func fill(with view: UIView, spacing: CGFloat = 0, considerMargins: Bool = false) {
        let topAnchor = considerMargins ? layoutMarginsGuide.topAnchor : topAnchor
        let leftAnchor = considerMargins ? layoutMarginsGuide.leftAnchor : leftAnchor
        let rightAnchor = considerMargins ? layoutMarginsGuide.rightAnchor : rightAnchor
        let bottomAnchor = considerMargins ? layoutMarginsGuide.bottomAnchor : bottomAnchor
        
        addSubviews(view)
        [view.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
         view.leftAnchor.constraint(equalTo: leftAnchor, constant: spacing),
         view.rightAnchor.constraint(equalTo: rightAnchor, constant: -spacing),
         view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing),
        ].activate()
    }
    
    func fill(with view: UIView, insets: UIEdgeInsets, considerMargins: Bool = false) {
        let topAnchor = considerMargins ? layoutMarginsGuide.topAnchor : topAnchor
        let leftAnchor = considerMargins ? layoutMarginsGuide.leftAnchor : leftAnchor
        let rightAnchor = considerMargins ? layoutMarginsGuide.rightAnchor : rightAnchor
        let bottomAnchor = considerMargins ? layoutMarginsGuide.bottomAnchor : bottomAnchor
        
        addSubviews(view)
        [view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
         view.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left),
         view.rightAnchor.constraint(equalTo: rightAnchor, constant: insets.right),
         view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom),
        ].activate()
    }
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach ({
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        })
    }
    
    func setVerticalGradientBackground(topColor top: UIColor, bottomColor bottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [top.cgColor, bottom.cgColor]
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
}

