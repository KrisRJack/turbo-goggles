//
//  DatabaseService.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/18/22.
//

import Firebase
import FirebaseFirestore

public final class DatabaseService {
    
    public enum CollectionPath: String {
        case users = "users"
        case usernames = "usernames"
        case channels = "channels"
        case market = "market"
        case messages = "messages"
    }

    public static func collection(_ collectionPath: CollectionPath) -> CollectionReference {
        return Firestore.firestore().collection(collectionPath.rawValue)
    }
    
    public static func document(_ documentPath: String) -> DocumentReference {
        return Firestore.firestore().document(documentPath)
    }
    
}

extension DocumentReference {
    
    public func collection(_ collectionPath: DatabaseService.CollectionPath) -> CollectionReference {
        return self.collection(collectionPath.rawValue)
    }
    
}
