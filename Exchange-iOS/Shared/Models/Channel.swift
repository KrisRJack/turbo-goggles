//
//  Channel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/24/22.
//

import Firebase
import Foundation
import RealmSwift

final class Channel: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var updated: Date = .init()
    @objc dynamic var lastMessage: Message? = .init()
    
    override static func primaryKey() -> String? { "id" }
    
    public var reference: DocumentReference {
        DatabaseService.collection(.channels).document(id)
    }
    
    public var imageReference: StorageReference? {
        guard let lastMessage = lastMessage else { return nil }
        return StorageService.reference(.users).child("\(lastMessage.fromUserID).\(String.jpegExtensionFormat)")
    }
    
    public var dictionary: [DatabaseKeys.Channel: Any] {
        [
            DatabaseKeys.Channel.id: id,
            DatabaseKeys.Channel.updated: updated
        ] 
    }
    
    public var rawValueDictionary: [String: Any] {
        var dictionary = Dictionary(uniqueKeysWithValues: dictionary.map { ($0.rawValue, $1) })
        guard let lastMessage = lastMessage else { return dictionary }
        return dictionary.merge(lastMessage.rawValueChannelDictionary)
    }
    
    public func channelReference(for userID: String) -> DocumentReference {
        DatabaseService.collection(.users).document(userID).collection(.channels).document(id)
    }
    
    convenience required init(id: String, updated: Date, lastMessage: Message) {
        self.init()
        self.id = id
        self.updated = updated
        self.lastMessage = lastMessage
    }
    
    convenience init(withData data: [String: Any]) {
        self.init()
        self.id = data[DatabaseKeys.Channel.id.rawValue] as? String ?? ""
        self.updated = (data[DatabaseKeys.Channel.updated.rawValue] as? Timestamp)?.dateValue() ?? Date()
        self.lastMessage = Message(withData: data, forChannelPreview: true)
    }
    
}
