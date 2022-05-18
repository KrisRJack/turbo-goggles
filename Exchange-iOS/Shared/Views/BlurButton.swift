//
//  BlurButton.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/18/22.
//

import UIKit 

open class BlurButton: UIButton {
    
    var hideBlurView: Bool {
        get { blurView.isHidden }
        set { blurView.isHidden = newValue }
    }
    
    var style: UIBlurEffect.Style {
        get { blurView.style }
        set { blurView.style = newValue }
    }
    
    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    var borderColor: UIColor {
        get { UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor) }
        set { layer.borderColor = newValue.cgColor }
    }
    
    private var blurView: BlurView!
    
    required public init(style: UIBlurEffect.Style = .dark) {
        super.init(frame: .zero)
        backgroundColor = .clear
        blurView = BlurView(style: style)
        blurView.frame.origin = .zero
        blurView.isExclusiveTouch = false
        blurView.frame.size = self.frame.size
        blurView.isUserInteractionEnabled = false
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
