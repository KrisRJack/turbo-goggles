//
//  MessagingViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/2/22.
//

import Foundation
import StreamChat

final class MessagingViewModel {
    
    typealias GetTextClosure = () -> String?
    typealias ReloadDataClosure = () -> Void
    typealias ShowErrorMessageClosure = (_ error: String) -> Void
    
    public var getText: GetTextClosure?
    public var reloadData: ReloadDataClosure?
    public var error: ShowErrorMessageClosure?
    public var navigationTitle: String { listing.displayName }
    
    private let listing: Listing
    private var channelController: ChatChannelController?
    
    init(with listing: Listing) {
        self.listing = listing
        guard let currentUser = UserStore.current else { return }
        configureChannelController(with: channelID(forUsers: [listing.userID, currentUser._id]))
    }
    
    private func configureChannelController(with channelID: String) {
        let channelId = ChannelId(type: .messaging, id: channelID)
        channelController = ChatClient.shared.channelController(for: channelId)
        channelController?.synchronize { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.error?(error.localizedDescription)
            }
        }
    }
    
    private func channelID(forUsers uids: Set<String>) -> String {
        return uids.compactMap({ $0 }).sorted().joined(separator: "_").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
}
