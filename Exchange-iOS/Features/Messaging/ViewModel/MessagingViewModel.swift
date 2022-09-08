//
//  MessagingViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 7/2/22.
//

import Firebase
import Foundation
import RealmSwift

final class MessagingViewModel {
    
    typealias ReloadDataClosure = () -> Void
    typealias DidSendMessageClosure = () -> Void
    typealias ShowErrorMessageClosure = (_ error: String) -> Void
    
    // MARK: - Init
    
    init(with listing: Listing) {
        self.listing = listing
        guard let currentUser = UserStore.current else { fatalError("User must be signed in!") }
        userIDs = [listing.userID, currentUser._id]
        channelID = channelID(forUsers: userIDs)
    }
    
    // MARK: - Public
    
    public var reloadData: ReloadDataClosure?
    public var error: ShowErrorMessageClosure?
    public var didSendMessage: DidSendMessageClosure?
    
    public var numberOfSections: Int { 1 }
    public var navigationTitle: String { listing.displayName }
    public var numberOfRowsInSection: [Int] { [messages?.count ?? 0] }
    
    /// View model should gather latest messages from backend in `viewDidLoad`.
    /// If there is no message on device,  get all messages and save to disk.
    public func viewDidLoad() {
        if let latestMessageDocumentOnDisk = latestMessageDocumentOnDisk {
            getAllMessages(from: latestMessageDocumentOnDisk)
        } else {
            getAllMessages()
        }
    }
    
    /// Gathers text and sends to another user when the current user taps the send button.
    /// - Parameter text: Text that the currently user would like to send to another user.
    public func didTapSend(text: String?) {
        guard let currentUser = UserStore.current,
              let text = text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty else { return }
        
        let channelReference = DatabaseService.collection(.channels).document(channelID)
        let newMessageReference = channelReference.collection(.messages).document()
        
        let message = Message(
            id: newMessageReference.documentID,
            channelID: channelID,
            fromUserID: currentUser._id,
            fromFirstName: currentUser.firstName,
            fromLastName: currentUser.lastName,
            fromDisplayName: currentUser.displayName,
            fromUsername: currentUser.username,
            text: text,
            date: .init(),
            type: .direct
        )
        
        let channel = Channel(
            id: channelID,
            updated: message.date,
            lastMessage: message
        )
        
        message.channelReference.setData(channel.rawValueDictionary, merge: true)
        newMessageReference.setData(message.rawValueDictionary, merge: true)
        userIDs.forEach ({
            DatabaseService
                .collection(.users)
                .document($0)
                .collection(.channels)
                .document(channelID)
                .setData(channel.rawValueDictionary, merge: true)
        })
        
        didSendMessage?()
    }
    
    
    /// Function returns a `Message` at a given index (determined by `numberOfRowsInSection`). Most recent `Message` will be stored at the the last index.
    /// - Parameter index: Index of `Message`
    /// - Returns: Returns a `Message` at the provided index
    public func message(forItemAtIndex index: Int) -> Message { messages![index] }
    
    // MARK: - Private
    
    private let listing: Listing
    private var channelID: String!
    private let userIDs: Set<String>
    private var latestMessageSnapshot: DocumentSnapshot?
    
    private var channelDocument: DocumentReference {
        return DatabaseService
            .collection(.channels)
            .document(channelID)
    }
    
    private var channelMessageCollection: CollectionReference {
        return DatabaseService
            .collection(.channels)
            .document(channelID)
            .collection(.messages)
    }
    
    private var messages: Results<Message>? {
        guard let channelID = channelID else { return nil }
        return try? Realm()
            .objects(Message.self)
            .where({ $0.channelID == channelID })
            .sorted(byKeyPath: DatabaseKeys.Message.date.rawValue, ascending: true)
    }
    
    private var latestMessageOnDisk: Message? {
        return messages?.first
    }
    
    private var latestMessageDocumentOnDisk: DocumentReference? {
        var messageDocument: DocumentReference?
        if let latestMessageOnDisk = latestMessageOnDisk {
            messageDocument = DatabaseService
                .collection(.channels)
                .document(channelID)
                .collection(.messages)
                .document(latestMessageOnDisk.id)
        }
        return messageDocument
    }
    
    private func channelID(forUsers uids: Set<String>) -> String {
        return uids.compactMap({ $0 }).sorted().joined(separator: "_").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    private func getAllMessages() {
        channelMessageCollection.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.error?(error.localizedDescription)
                self.reloadData?()
                return
            }
            
            guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                self.reloadData?()
                return
            }
            
            snapshot.documents.forEach ({ self.saveMessageDocumentToDisk(document: $0) })
            self.latestMessageSnapshot = snapshot.documents.last
            self.reloadData?()
            return
        }
    }
    
    private func getAllMessages(from messageDocument: DocumentReference) {
        messageDocument.getDocument { [weak self] messageSnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.error?(error.localizedDescription)
                self.reloadData?()
                return
            }
            
            guard let messageSnapshot = messageSnapshot else {
                self.reloadData?()
                return
            }
            
            self.channelMessageCollection
                .order(by: DatabaseKeys.Message.date.rawValue, descending: false)
                .start(afterDocument: messageSnapshot)
                .addSnapshotListener { [weak self] snapshot, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        self.error?(error.localizedDescription)
                        self.reloadData?()
                        return
                    }
                    
                    guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                        self.reloadData?()
                        return
                    }
                    
                    snapshot.documents.forEach ({ self.saveMessageDocumentToDisk(document: $0) })
                    self.latestMessageSnapshot = snapshot.documents.last
                    self.reloadData?()
                    return
                }
        }
    }
    
    private func saveMessageDocumentToDisk(document: QueryDocumentSnapshot) {
        do {
            let realm = try Realm()
            try realm.write { realm.add(Message(withData: document.data()), update: .modified) }
        } catch(let error) { self.error?(error.localizedDescription) }
    }
    
}
