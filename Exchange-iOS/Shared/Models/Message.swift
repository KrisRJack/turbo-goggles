//
//  Message.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/24/22.
//

import Firebase
import Foundation
import RealmSwift

enum MessageType: String {
    case direct = "DIRECT"
}

final class Message: Object {
    
    typealias MessageTypeRawValue = String
    
    @objc dynamic var id: String = ""
    @objc dynamic var channelID: String = ""
    @objc dynamic var fromUserID: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var date: Date = .init()
    @objc dynamic var typeRawValue: MessageTypeRawValue {
        get { type.rawValue }
        set { type = MessageType(rawValue: newValue) ?? .direct }
    }
    
    var type: MessageType = .direct
    
    override static func primaryKey() -> String? { "id" }
    
    public var isSentByCurrentUser: Bool {
        guard let currentUser = UserStore.current else { fatalError("User must be signed in!") }
        return currentUser._id == fromUserID
    }
    
    public var reference: DocumentReference {
        channelReference.collection(.messages).document(id)
    }
    
    public var channelReference: DocumentReference {
        DatabaseService.collection(.channels).document(channelID)
    }
    
    public var messageReference: DocumentReference {
        DatabaseService.collection(.channels).document(channelID).collection(.messages).document(id)
    }
    
    public var userReference: DocumentReference {
        DatabaseService.collection(.users).document(fromUserID)
    }
    
    public var dictionary: [DatabaseKeys.Message: Any] {
        [
            DatabaseKeys.Message.id: id,
            DatabaseKeys.Message.channelID: channelID,
            DatabaseKeys.Message.fromUserID: fromUserID,
            DatabaseKeys.Message.text: text,
            DatabaseKeys.Message.date: date.timestamp,
            DatabaseKeys.Message.type: typeRawValue
        ]
    }
    
    public var rawValueDictionary: [String: Any] {
        Dictionary(uniqueKeysWithValues: dictionary.map { ($0.rawValue, $1) })
    }
    
    public var rawValueChannelDictionary: [String: Any] {
        Dictionary(uniqueKeysWithValues: dictionary.map { ("message_\($0)", $1) })
    }
    
    convenience required init(
        id: String,
        channelID: String,
        fromUserID: String,
        text: String,
        date: Date,
        type: MessageType
    ) {
        self.init()
        self.id = id
        self.channelID = channelID
        self.fromUserID = fromUserID
        self.text = text
        self.date = date
        self.type = type
    }
    
    convenience init(withData data: [String: Any]) {
        self.init()
        self.id = data[DatabaseKeys.Message.id.rawValue] as? String ?? ""
        self.channelID = data[DatabaseKeys.Message.channelID.rawValue] as? String ?? ""
        self.fromUserID = data[DatabaseKeys.Message.fromUserID.rawValue] as? String ?? ""
        self.text = data[DatabaseKeys.Message.text.rawValue] as? String ?? ""
        self.date = (data[DatabaseKeys.Message.date.rawValue] as? Timestamp)?.dateValue() ?? Date()
        self.type = MessageType(rawValue: data[DatabaseKeys.Message.type.rawValue] as? String ?? MessageType.direct.rawValue) ?? .direct
    }
    
}
