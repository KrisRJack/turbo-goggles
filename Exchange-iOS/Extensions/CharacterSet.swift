//
//  CharacterSet.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 2/7/22.
//

import Foundation

extension CharacterSet {
    public static let URLAllowed = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~:/?#[]@!$&'()*+,;=%")
    public static let SearchTermsAllowed = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789*-_.")
}
