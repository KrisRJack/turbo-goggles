//
//  UICollectionViewCell.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 2/26/22.
//

import UIKit

extension UICollectionViewCell {
    
    public static var reuseIdentifier: String {
        return String(describing: self.self)
    }
    
}

