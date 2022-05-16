//
//  ForgotPasswordViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/16/22.
//

import Firebase

final class ForgotPasswordViewModel {
    
    public struct Credentials {
        let email: () -> String?
    }
    
    public var numberOfSections: Int { 1 }
    public var numberOfRowsInSection: Int { 1 }
    public var didSendResetEmail: (() -> Void)?
    public var error: ((_ string: String) -> Void)?
    private let credentialsListener: Credentials!
    
    private var email: String {
        credentialsListener.email()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    init(credentials: Credentials) {
        credentialsListener = credentials
    }
    
    public func sendEmailToResetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.error?(error.localizedDescription)
                return
            }
            
            self.didSendResetEmail?()
        }
        
    }
    
}
