//
//  UserStore.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/18/22.
//

import Firebase
import RealmSwift

class UserStore: Object {
    
    @objc dynamic var _id: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var displayName: String = ""
    @objc dynamic var created: Date = Date()
    @objc dynamic var dateOfBirth: Date = Date()
    
    override static func primaryKey() -> String? { "_id" }
    
    public var imageReference: StorageReference {
        StorageService.reference(.users).child("\(_id).\(String.jpegExtensionFormat)")
    }
    
    public static var current: UserStore? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        do {
            
            let realm = try Realm()
            return realm.object(ofType: UserStore.self, forPrimaryKey: currentUser.uid)
            
        } catch {
            
            print("Error: \(error.localizedDescription)")
            return nil
            
        }
    }
    
    public var dictionary: [String: Any] {
        [
            DatabaseKeys.User.uid.rawValue: _id,
            DatabaseKeys.User.email.rawValue: email,
            DatabaseKeys.User.firstName.rawValue: firstName,
            DatabaseKeys.User.lastName.rawValue: lastName,
            DatabaseKeys.User.username.rawValue: username,
            DatabaseKeys.User.displayName.rawValue: displayName,
            DatabaseKeys.User.created.rawValue: created,
            DatabaseKeys.User.dateOfBirth.rawValue: dateOfBirth
        ]
    }
    
    public var firebaseDictionary: [String: Any] {
        [
            DatabaseKeys.User.uid.rawValue: _id,
            DatabaseKeys.User.email.rawValue: email,
            DatabaseKeys.User.firstName.rawValue: firstName,
            DatabaseKeys.User.lastName.rawValue: lastName,
            DatabaseKeys.User.username.rawValue: username,
            DatabaseKeys.User.displayName.rawValue: displayName,
            DatabaseKeys.User.created.rawValue: Timestamp(date: created),
            DatabaseKeys.User.dateOfBirth.rawValue: Timestamp(date: dateOfBirth)
        ]
    }
    
    convenience required init(
        uid: String,
        email: String,
        firstName: String,
        lastName: String,
        username: String,
        displayName: String,
        created: Date,
        dateOfBirth: Date
    ) {
        self.init()
        self._id = uid
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.displayName = displayName
        self.created = created
        self.dateOfBirth = dateOfBirth
    }
    
    convenience init(withData data: [String: Any]) {
        self.init()
        self._id = data[DatabaseKeys.User.uid.rawValue] as? String ?? ""
        self.email = data[DatabaseKeys.User.email.rawValue] as? String ?? ""
        self.firstName = data[DatabaseKeys.User.firstName.rawValue] as? String ?? ""
        self.lastName = data[DatabaseKeys.User.lastName.rawValue] as? String ?? ""
        self.username = data[DatabaseKeys.User.username.rawValue] as? String ?? ""
        self.displayName = data[DatabaseKeys.User.displayName.rawValue] as? String ?? ""
        self.created = (data[DatabaseKeys.User.created.rawValue] as? Timestamp)?.dateValue() ?? Date()
        self.dateOfBirth = (data[DatabaseKeys.User.dateOfBirth.rawValue] as? Timestamp)?.dateValue() ?? Date()
    }
    
    public func saveToDisk() throws {
        let realm = try Realm()
        try realm.write { realm.add(self, update: .modified) }
    }
    
}
