//
//  Username.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/23/22.
//

import Firebase

struct Username {
    
    let id: String
    let updated: Date
    let userID: String
    let username: String
    
    var firebaseDictionary: [String: Any] {
        [
            DatabaseKeys.Username.id.rawValue: id,
            DatabaseKeys.Username.username.rawValue: username,
            DatabaseKeys.Username.userID.rawValue: userID,
            DatabaseKeys.Username.updated.rawValue: Timestamp(date: updated)
        ]
    }
    
}
