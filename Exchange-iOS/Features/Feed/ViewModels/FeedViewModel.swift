//
//  FeedViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/16/22.
//

import Firebase

final class FeedViewModel {
    
    public var reloadData: (() -> Void)?
    public var error: ((_ string: String) -> Void)?
    public var numberOfSections: Int = 1
    public var numberOfRowsInSection: [Int:Int] { [0: listedItems.count] }
    
    private var batchSize = 10
    private var listedItems: [Listing] = []
    private var didGetOldestDocument: Bool = false
    private var newestDocument: QueryDocumentSnapshot?
    private var oldestDocument: QueryDocumentSnapshot?
    
    private var ascendingQuery: Query {
        DatabaseService
            .collection(.market)
            .order(by: DatabaseKeys.Listing.created.rawValue, descending: false)
    }
    
    private var descendingQuery: Query {
        DatabaseService
            .collection(.market)
            .order(by: DatabaseKeys.Listing.created.rawValue, descending: true)
    }
    
    public func loadInitialBatch() {
        descendingQuery
            .limit(to: batchSize)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.error?(error.localizedDescription)
                    return
                }
                
                guard let snapshot = snapshot else {
                    self.reloadData?()
                    return
                }
                
                self.newestDocument = snapshot.documents.first
                self.oldestDocument = snapshot.documents.last
                self.didGetOldestDocument = snapshot.documents.count < self.batchSize
                
                self.listedItems = snapshot.documents.map ({ document in
                    return Listing(withData: document.data())
                })
                
                self.reloadData?()
            }
    }
    
    public func paginateNewerBatch() {
        guard let newestDocument = newestDocument else {
            loadInitialBatch()
            return
        }
        
        ascendingQuery
            .start(afterDocument: newestDocument)
            .limit(to: batchSize)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.error?(error.localizedDescription)
                    return
                }
                
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    self.reloadData?()
                    return
                }
                
                self.newestDocument = snapshot.documents.last
                let newData: [Listing] = snapshot.documents.reversed().map({ document in
                    return Listing(withData: document.data())
                })
                
                self.listedItems = newData + self.listedItems
                self.reloadData?()
            }
    }
    
    public func paginateOlderBatch() {
        if didGetOldestDocument { return }
        
        guard let oldestDocument = oldestDocument else {
            loadInitialBatch()
            return
        }
        
        descendingQuery
            .start(afterDocument: oldestDocument)
            .limit(to: batchSize)
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    self.error?(error.localizedDescription)
                    return
                }
                
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    self.reloadData?()
                    return
                }
                
                self.oldestDocument = snapshot.documents.last
                self.didGetOldestDocument = snapshot.documents.count < self.batchSize
                
                let olderData: [Listing] = snapshot.documents.reversed().map({ document in
                    return Listing(withData: document.data())
                })
                
                self.listedItems = self.listedItems + olderData
                self.reloadData?()
            }
    }
    
    public func listingForCell(at indexPath: IndexPath) -> Listing {
        return listedItems[indexPath.row]
    }

}
