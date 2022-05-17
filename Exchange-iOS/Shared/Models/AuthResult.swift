//
//  AuthResult.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/23/22.
//

import Firebase

public struct AuthResult {
    let uid: String
    let email: String
    let created: Date
    let result: AuthDataResult
}
