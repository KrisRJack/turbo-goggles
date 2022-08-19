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
    
    enum Listing: String, DatabaseKeyType {
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
    
    enum Channel: String, DatabaseKeyType {
        case id = "id"
        case created = "create"
        case message_id = "message_id"
        case message_channelID = "message_channelID"
        case message_fromUserID = "message_fromUserID"
        case message_text = "message_text"
        case message_date = "message_date"
        case message_type = "message_type"
    }
    
    enum Message: String, DatabaseKeyType {
        case id = "id"
        case channelID = "channelID"
        case fromUserID = "fromUserID"
        case text = "text"
        case date = "date"
        case type = "type"
    }

}
