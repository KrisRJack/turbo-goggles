//
//  OnboardViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/21/22.
//

import Firebase

final class OnboardViewModel {
    
    public struct Input {
        let firstName: () -> String?
        let lastName: () -> String?
        let username: () -> String?
        let dateOfBirth: () -> String?
    }
    
    public var numberOfSections: Int { 1 }
    public var numberOfRowsInSection: Int { 1 }
    public var error: ((_ string: String) -> Void)?
    public var didOnboard: ((_ user: UserStore) -> Void)?
    
    private let inputListener: Input!
    private let authResult: AuthResult!
    
    private var firstName: String {
        inputListener.firstName()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    private var lastName: String {
        inputListener.lastName()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    private var dateOfBirthString: String {
        inputListener.dateOfBirth()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    private var dateOfBirth: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = .dateOfBirthFormat
        guard let dob = formatter.date(from: dateOfBirthString) else {
            return nil
        }
        return dob
    }
    
    private var username: UsernameService {
        UsernameService(
            username: inputListener.username()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "",
            userID: authResult.uid
        )
    }
    
    init(authResult result: AuthResult, input: Input) {
        authResult = result
        inputListener = input
    }
    
    public func onboard() {
        if firstName.isEmpty || lastName.isEmpty || username.username.isEmpty {
            error?(NSLocalizedString("REQUIRED_FIELDS_ERROR", comment: "Error"))
            return
        }
        
        if !username.isValid {
            error?(NSLocalizedString("USER_NAME_ERROR", comment: "Error"))
            return
        }
        
        if dateOfBirth == nil {
            error?("Date of birth is not the correct format.")
            return
        }
        
        verifyThatUsernameIsNotTaken()
    }
    
    private func verifyThatUsernameIsNotTaken() {
        username.isTaken { [weak self] taken, error in
            guard let self = self else { return }
            
            if let error = error {
                self.error?(error.localizedDescription)
                return
            }
            
            if taken {
                self.error?("Username is taken.")
                return
            }
            
            self.addUsernameToDatabase()
        }
    }
    
    private func addUsernameToDatabase() {
        username.add { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.error?(error.localizedDescription)
                return
            }
            
            self.storeUser()
        }
    }
    
    private func storeUser() {
        guard let dateOfBirth = dateOfBirth else {
            username.delete()
            self.error?(NSLocalizedString("DEVELOPER_ERROR", comment: "Error"))
            return
        }
        
        let user = UserStore(
            uid: authResult.uid,
            email: authResult.email,
            firstName: firstName,
            lastName: lastName,
            username: username.username,
            displayName: "\(firstName) \(lastName)",
            created: authResult.created,
            dateOfBirth: dateOfBirth
        )
        
        DatabaseService
            .collection(.users)
            .document(self.authResult.uid)
            .setData(user.firebaseDictionary, merge: true) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    self.username.delete()
                    self.error?(error.localizedDescription)
                    return
                }
                
                do {
                    
                    try user.saveToDisk()
                    self.didOnboard?(user)
                    
                } catch (let error) {
                    
                    self.error?(error.localizedDescription)
                    
                }
                
            }
        
    }
    
}
