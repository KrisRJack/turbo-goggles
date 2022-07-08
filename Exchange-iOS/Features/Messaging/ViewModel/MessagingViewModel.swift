//
//  MessagingViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/2/22.
//

import Foundation
import StreamChat

final class MessagingViewModel {
    
    typealias ReloadDataClosure = () -> Void
    typealias DidSendMessageClosure = () -> Void
    typealias ShowErrorMessageClosure = (_ error: String) -> Void
    
    public var reloadData: ReloadDataClosure?
    public var error: ShowErrorMessageClosure?
    public var didSendMessage: DidSendMessageClosure?
    public var navigationTitle: String { listing.displayName }
    
    private let listing: Listing
    private var channelController: ChatChannelController?
    
    init(with listing: Listing) {
        self.listing = listing
        guard let currentUser = UserStore.current else { return }
        configureChannelController(with: channelID(forUsers: [listing.userID, currentUser._id]))
    }
    
    public func didTapSend(text: String?) {
        guard let text = text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        channelController?.createNewMessage(text: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                self.error?(error.localizedDescription)
            default:
                self.didSendMessage?()
            }
        }
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
