//
//  Sequence.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/22/22.
//

import Foundation

extension Sequence where Iterator.Element == NSAttributedString {
    func joined(separator: NSAttributedString) -> NSAttributedString {
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if r.length > 0 {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }
    func joined(separator: String = "") -> NSAttributedString {
        return self.joined(separator: NSAttributedString(string: separator))
    }
}
