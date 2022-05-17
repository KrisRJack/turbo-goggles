//
//  SignUpViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/18/22.
//

import Firebase
import RealmSwift

final class SignUpViewModel {
    
    public struct Credentials {
        let email: () -> String?
        let password: () -> String?
    }

    public var numberOfSections: Int { 1 }
    public var numberOfRowsInSection: Int { 1 }
    public var error: ((_ string: String) -> Void)?
    public var didSignUp: ((_ result: AuthResult) -> Void)?
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
    
    public func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.signOut()
                self.error?(error.localizedDescription)
                return
            }
            
            guard let result = result, let email = result.user.email, let created = result.user.metadata.creationDate else {
                self.signOut()
                self.error?("Failed to create account.")
                return
            }
            
            self.didSignUp?(AuthResult(uid: result.user.uid, email: email, created: created, result: result))
        }
    }
    
    public func signOut() {
        try? Auth.auth().signOut()
    }
}
