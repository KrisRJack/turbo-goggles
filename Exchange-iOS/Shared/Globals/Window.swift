//
//  Window.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/18/22.
//

import UIKit

let window = UIApplication.shared.connectedScenes
    .filter({$0.activationState == .foregroundActive})
    .map({$0 as? UIWindowScene})
    .compactMap({$0})
    .first?.windows
    .filter({$0.isKeyWindow}).first
