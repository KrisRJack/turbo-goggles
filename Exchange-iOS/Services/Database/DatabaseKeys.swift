//
//  DatabaseKeys.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/18/22.
//

public struct DatabaseKeys {
    
    public enum User: String, DatabaseKeyType {
        case uid = "uid"
        case email = "email"
        case firstName = "firstName"
        case lastName = "lastName"
        case displayName = "displayName"
        case username = "username"
        case created = "created"
        case dateOfBirth = "dateOfBirth"
    }
    
    public enum Username: String, DatabaseKeyType {
        case id = "id"
        case userID = "userID"
        case updated = "updated"
        case username = "username"
    }

}
