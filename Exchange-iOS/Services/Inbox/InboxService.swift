//
//  InboxService.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 8/25/22.
//

import UIKit
import Firebase
import RealmSwift

protocol InboxServiceType {
    var numberOfChannels: Int { get }
    func channel(atIndex index: Int) -> Result<Channel, Error>
    func listenAndAddDataToDisk(completion: @escaping (_ error: Error?) -> Void)
}

final class InboxService: InboxServiceType {
    
    public var numberOfChannels: Int { channels?.count ?? 0 }
    
    private var user: UserStore
    private var channels: Results<Channel>?
    private var latestChannelOnDisk: Channel?
    
    init(forUser user: UserStore) throws {
        self.user = user
        channels = try Realm()
            .objects(Channel.self)
            .sorted(byKeyPath: DatabaseKeys.Channel.updated.rawValue, ascending: true)
        latestChannelOnDisk = channels?.first
    }
    
    public func listenAndAddDataToDisk(completion: @escaping (_ error: Error?) -> Void) {
        if let latestChannelOnDisk = latestChannelOnDisk {
            latestChannelOnDisk.reference.getDocument { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    completion(error)
                    return
                }
                
                self.listenAndSaveDocumentsToDisk(startingAfter: snapshot) { error in
                    completion(error)
                }
            }
        } else {
            listenAndSaveDocumentsToDisk { error in
                completion(error)
            }
        }
    }
    
    public func channel(atIndex index: Int) -> Result<Channel, Error> {
        do {
            
            let object = try Realm()
                .objects(Channel.self)
                .sorted(byKeyPath: DatabaseKeys.Channel.updated.rawValue, ascending: false)[index]
            return .success(object)
            
        } catch(let error) {
            
            return .failure(error)
            
        }
    }
    
    // MARK: - Private
    
    private func listenAndSaveDocumentsToDisk(
        startingAfter latestDocument: DocumentSnapshot? = nil,
        completion: @escaping (_ error: Error?) -> Void
    ) {
        var userChannels = user.channelReference
            .order(by: DatabaseKeys.Channel.updated.rawValue, descending: false)
        
        if let latestDocument = latestDocument {
            userChannels = userChannels.start(afterDocument: latestDocument)
        }
        
        userChannels.getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            for document in snapshot.documents {
                let channel = Channel(withData: document.data())
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(channel, update: .modified)
                        self.latestChannelOnDisk = channel
                    }
                } catch(let error) {
                    completion(error)
                    return
                }
            }
            
            completion(nil)
            return
        }
    }
    
}
