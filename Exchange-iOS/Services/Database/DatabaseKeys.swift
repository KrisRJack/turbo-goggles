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
    
    enum Listing: String, CaseIterable {
        case id = "id"
        case userID = "userID"
        case displayName = "displayName"
        case username = "username"
        case sold = "sold"
        case header = "header"
        case price = "price"
        case size = "size"
        case description = "description"
        case condition = "condition"
        case category = "category"
        case tags = "tags"
        case created = "created"
        case item_id = "item_id"
        case item_imageName = "item_imageName"
        case item_description = "item_description"
    }

}
