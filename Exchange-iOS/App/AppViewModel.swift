//
//  AppViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import Firebase
import RealmSwift

final class AppViewModel {
    
    enum AppScenes {
        case auth
        case home
    }
    
    public static func currentScene() -> AppScenes {
        guard let currentUser = Auth.auth().currentUser else { return .auth }
        
        do {
            
            let realm = try Realm()
            guard let user: UserStore = realm.object(ofType: UserStore.self, forPrimaryKey: currentUser.uid),
                  (!user.email.isEmpty && !user.firstName.isEmpty) else {
                try Auth.auth().signOut()
                return .auth
            }
            
            return .home
            
        } catch {
            
            try? Auth.auth().signOut()
            return .auth
            
        }
        
    }
    
}
