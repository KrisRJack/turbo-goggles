//
//  NSMutableAttributedString.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/22/22.
//

import UIKit

extension NSMutableAttributedString {
    
    @discardableResult
    func append(_ text: String, withFont font: UIFont, withColor color: UIColor = .label) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let string = NSMutableAttributedString(string:text, attributes: attrs)
        append(string)
        return self
    }
    
}
