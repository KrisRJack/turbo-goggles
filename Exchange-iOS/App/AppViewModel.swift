//
//  AppViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import Firebase

final class AppViewModel {
    
    enum AppScenes {
        case auth
        case home
    }
    
    public static func currentScene() -> AppScenes {
        return Auth.auth().currentUser == nil ? .auth : .home
    }
    
}
