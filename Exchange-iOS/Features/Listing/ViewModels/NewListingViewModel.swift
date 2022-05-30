//
//  NewListingViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/28/22.
//

import Firebase

final class NewListingViewModel {
    
    public struct Input {
        var title: (() -> String?)?
        var price: (() -> String?)?
        var description: (() -> String?)?
        var size: (() -> String?)?
        var tags: (() -> String?)?
        var condition: (() -> String?)?
        var category: (() -> String?)?
    }
    
    public var inputListener: Input = Input()
    public var didCreateListing: (() -> Void)?
    public var error: ((_ string: String) -> Void)?
    public var shouldEditImages: ((_ indexPath: IndexPath, _ images: ReferenceArray<ListingImage>) -> Void)?
    
    private let images: ReferenceArray<ListingImage>
    
    init(images: ReferenceArray<ListingImage>) {
        self.images = images
    }
    
    public func shouldEditImage(at indexPath: IndexPath) {
        shouldEditImages?(indexPath, images)
    }
    
    public func postButtonPressed() {
        guard let user = Auth.auth().currentUser else {
            error?("User must be signed in to create a new listing.")
            return
        }
        
        guard
            let titleString = formatOptionalString(inputListener.title?()),
            let priceString = formatOptionalString(inputListener.price?()),
            !images.isEmpty
        else {
            error?("Title, price, and at least one image are required to create listing.")
            return
        }
        
        guard let price = Decimal(string: priceString) else {
            error?("Price format is not valid.")
            return
        }
        
        let reference = DatabaseService.collection(.market).document()
        
        var items: [Listing.Item] = []
        images.enumerated().forEach { (index, item) in
            let item = Listing.Item(id: "\(reference.documentID)_\(index)", description: item.description)
            items.append(item)
        }
        
        let listing = Listing(
            id: reference.documentID,
            created: Date(),
            description: formatOptionalString(inputListener.description?()),
            userID: user.uid,
            header: titleString,
            price: price,
            size: formatOptionalString(inputListener.size?()),
            condition: formatOptionalString(inputListener.condition?()),
            category: formatOptionalString(inputListener.category?()),
            tags: formatTags(string: formatOptionalString(inputListener.tags?())),
            items: items
        )
        
        
        // TODO: Save images to Firebase Storage
        
        
        let userReference = DatabaseService.collection(.users).document(user.uid)
        let userListingsReference = userReference.collection(.market)
        
        userListingsReference.document(reference.documentID).setData(listing.toDictionary, merge: true) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.error?(error.localizedDescription)
                return
            }
            
            reference.setData(listing.toDictionary, merge: true) { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    userListingsReference.document(reference.documentID).delete()
                    self.error?(error.localizedDescription)
                    return
                }
                
                self.didCreateListing?()
            }
        }
        
    }
    
    private func formatTags(string: String?) -> [String]? {
        guard let tagsString = string, !tagsString.isEmpty else { return nil }
        let tagArray: [String] = tagsString.split{ $0 == "," }.map(String.init)
        // We don't want duplicate tags
        let tagsSet = Set(tagArray.map({
            ($0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())
                .replacingOccurrences(of: " ", with: "-")
        }))
        return Array(tagsSet)
    }
    
    private func formatOptionalString(_ string: String?) -> String? {
        guard let string = string?.trimmingCharacters(in: .whitespacesAndNewlines), !string.isEmpty else { return nil }
        return string
    }
    
}
