//
//  ScaledHeightImageView.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/22/22.
//

import UIKit

open class ScaledHeightImageView: UIImageView {
    
    open override var image: UIImage? {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        if let image = image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            let viewWidth = frame.size.width
            let ratio = viewWidth/imageWidth
            let scaledHeight = imageHeight * ratio
            return CGSize(width: viewWidth, height: scaledHeight)
        }
        return CGSize(width: -1.0, height: -1.0)
    }
    
}
