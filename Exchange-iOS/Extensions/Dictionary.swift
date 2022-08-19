//
//  Dictionary.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/24/22.
//

import Foundation

extension Dictionary {
    
    @discardableResult
    /// Combines the contents of a given dictionary into the current dictionary. A `key` already exists, function will update the value.
    /// - Parameter dictionary: New dictionary to merge into the current dictionary.
    /// - Returns: Returns the current dictionary with merged `key: values` pairs.
    mutating func merge(_ dictionary: [Key: Value]) -> [Key: Value] {
        for (key, value) in dictionary {
            updateValue(value, forKey: key)
        }
        return self
    }
    
}
