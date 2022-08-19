//
//  Channel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/24/22.
//

import Firebase
import Foundation

struct Channel {
    
    let id: String
    let lastMessage: Message
    
    public var reference: DocumentReference {
        DatabaseService.collection(.channels).document(id)
    }
    
    public var dictionary: [DatabaseKeys.Channel: Any] {
        [
            DatabaseKeys.Channel.id: id
        ] 
    }
    
    public var rawValueDictionary: [String: Any] {
        var dictionary = Dictionary(uniqueKeysWithValues: dictionary.map { ($0.rawValue, $1) })
        return dictionary.merge(lastMessage.rawValueChannelDictionary)
    }
    
    public func channelReference(for userID: String) -> DocumentReference {
        DatabaseService.collection(.users).document(userID).collection(.channels).document(id)
    }
    
}
