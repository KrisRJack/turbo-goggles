//
//  BlurView.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/18/22.
//

import UIKit

open class BlurView: UIView {
    
    var style: UIBlurEffect.Style {
        get { effectStyle }
        set {
            effectStyle = newValue
            createBlurView(withStyle: newValue)
        }
    }
    
    private var blurView: UIVisualEffectView!
    private var effectStyle: UIBlurEffect.Style!
    
    required public init(style: UIBlurEffect.Style = .dark) {
        super.init(frame: .zero)
        backgroundColor = .clear
        effectStyle = style
        createBlurView(withStyle: style)
        addSubview(blurView)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBlurView(withStyle style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let view = UIVisualEffectView(effect: blurEffect)
        view.frame.origin = .zero
        view.frame.size = frame.size
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView = view
    }

}
