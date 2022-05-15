//
//  LoginViewModel.swift
//  Exchange
//
//  Created by Kristopher Jackson on 4/13/22.
//

import Firebase
import RealmSwift

final class LoginViewModel {
    
    public struct Credentials {
        let email: () -> String?
        let password: () -> String?
    }
    
    public var numberOfSections: Int { 1 }
    public var didLogInWithUser: (() -> Void)?
    public var numberOfRowsInSection: Int { 1 }
    public var didLogInWithoutUser: ((_ result: AuthResult) -> Void)?
    public var error: ((_ string: String) -> Void)?
    private let credentialsListener: Credentials!
    
    private var email: String {
        credentialsListener.email()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    private var password: String {
        credentialsListener.password()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    init(credentials: Credentials) {
        credentialsListener = credentials
    }
    
    public func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.signOut()
                self.error?(error.localizedDescription)
                return
            }
            
            guard let uid = result?.user.uid else {
                self.signOut()
                self.error?("Failed to log in user.")
                return
            }
            
            let userCollection = DatabaseService.collection(.users)
            userCollection.document(uid).getDocument { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.signOut()
                    self.error?(error.localizedDescription)
                    return
                }
                
                guard let snapshot = snapshot, let data = snapshot.data() else {
                    
                    // If snapshot data is empty, we have a user that has not been onboarded
                    if let result = result, let email = result.user.email, let created = result.user.metadata.creationDate {
                        let authResult = AuthResult(uid: result.user.uid, email: email, created: created, result: result)
                        self.didLogInWithoutUser?(authResult)
                    } else {
                        self.signOut()
                        self.error?("Failed to log in user.")
                    }
                    
                    return
                    
                }
                
                let user = UserStore(withData: data)
                do {
                    
                    try user.saveToDisk()
                    self.didLogInWithUser?()
                    
                } catch (let error) {
                    
                    self.signOut()
                    self.error?(error.localizedDescription)
                    
                }
                
            }
        }
    }
    
    public func signOut() {
        try? Auth.auth().signOut()
    }
    
}
