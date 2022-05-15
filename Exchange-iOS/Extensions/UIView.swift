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
    
    func center(in view: UIView) {
        view.addSubview(self)
        [centerXAnchor.constraint(equalTo: view.centerXAnchor),
         centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ].activate()
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

