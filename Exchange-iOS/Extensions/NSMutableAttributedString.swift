//
//  NSMutableAttributedString.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/22/22.
//

import UIKit

extension NSMutableAttributedString {
    
    /**
     Appends an attributed string to an `NSMutableAttributedString`
     - Parameter text: Text intended to be formatted.
     - Parameter font: Preferred `UIFont` of the attributed text.
     - Parameter color: Preferred `UIColor` of the attributed text.
     - Returns: Returns the `NSMutableAttributedString` with appended text.
        
     Example usage:
     ```
     let label = UILabel()
     label.attributedText = NSMutableAttributedString()
         .append("This text will be 12 point font and black. ", withFont: .systemFont(ofSize: 12), color: .black)
         .append("This text will be 15 point font and gray.", withFont: .systemFont(ofSize: 15), color: .gray)
     ```
    */
    @discardableResult
    func append(_ text: String, withFont font: UIFont, color: UIColor = .label) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let string = NSMutableAttributedString(string:text, attributes: attrs)
        append(string)
        return self
    }
    
}
