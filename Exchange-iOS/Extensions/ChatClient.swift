//
//  ChatClient.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/28/22.
//

import StreamChat

extension ChatClient {
    
    static let shared: ChatClient = {
        let config = ChatClientConfig(apiKey: .init(APIKeys.Stream.apiKey))
        let client = ChatClient(config: config)
        return client
    }()
    
}
