//
//  UsernameService.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/23/22.
//

import Firebase

final class UsernameService {
    
    public var userID: String!
    public var username: String!
    
    public var usernameDocumentID: String {
        usernameDocument.documentID
    }
    
    public var usernameDocument: DocumentReference {
        DatabaseService.collection(.usernames).document(username.lowercased())
    }
    
    public var isValid: Bool {
        let characterset = CharacterSet(charactersIn: .validUsernameCharacters)
        return !(
            username.isEmpty ||
            username.count < 5 ||
            username.count > 20 ||
            username.rangeOfCharacter(from: characterset.inverted) != nil
        )
    }
    
    init(username: String, userID: String) {
        self.userID = userID
        self.username = username
    }
    
    public func isTaken(_ completion: @escaping (_ taken: Bool, _ error: Error?) -> Void) {
        usernameDocument.getDocument { snapshot, error in
            if let error = error {
                completion(true, error)
                return
            }
            completion(snapshot?.exists ?? false, nil)
        }
    }
    
    public func add(_ completion: @escaping (_ error: Error?) -> Void) {
        let username = Username(
            id: usernameDocumentID,
            updated: Date(),
            userID: userID,
            username: username
        )
        usernameDocument.setData(username.firebaseDictionary, merge: true) { error in
            completion(error)
        }
    }
    
    public func delete() {
        usernameDocument.delete()
    }
    
    public func delete(completion: ((Error?) -> Void)?) {
        usernameDocument.delete(completion: completion)
    }
    
}
