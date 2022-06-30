//
//  ChatService.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/29/22.
//

import StreamChat

final class ChatService {
    
    static func configure(forUser user: UserStore, _ completion: ((_ error: Error?) -> Void)? = nil) {
        user.imageReference.downloadURL { url, error in
            if let error = error {
                completion?(error)
                return
            }
            
            let config = ChatClientConfig(apiKey: .init(APIKeys.Stream.appAccessKey))
            ChatClient.shared = ChatClient(config: config)
            
            ChatClient.shared.connectUser(
                userInfo: UserInfo(
                    id: user._id,
                    name: user.displayName,
                    imageURL: url
                ),
                token: .development(userId: user._id) // TODO: Grab from Firebase Cloud
            )
            
        }
    }
    
}
