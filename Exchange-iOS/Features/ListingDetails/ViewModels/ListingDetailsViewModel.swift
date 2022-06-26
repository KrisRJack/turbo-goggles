//
//  ListingDetailsViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/26/22.
//

import Foundation
import FirebaseStorage

final class ListingDetailsViewModel {
    
    public var reloadData: (()-> Void)?
    public var numberOfSections: Int { 1 }
    public var title: String { listing.header }
    public var numberOfRowsInSection: [Int: Int] { [0: listing.imageReferences.count + 1] }
    public var headerModel: ListingDetailsHeaderView.Model {
        let pkHeader = PKHeader.Model(
            displayName: listing.displayName,
            username: listing.username,
            datePosted: listing.created,
            imageReference: listing.userImageReference
        )
        let model = ListingDetailsHeaderView.Model(
            header: pkHeader,
            formattedPrice: listing.formattedPrice,
            title: listing.header,
            description: listing.description,
            size: listing.size,
            condition: listing.condition,
            category: listing.category,
            tags: listing.tags
        )
        return model
    }
    
    private let listing: Listing
    private var didReload: Bool = false
    private var imageReferences: [StorageReference] { listing.imageReferences }
    private var imageDescriptions: [String?] { listing.imageDescriptions }
    
    init(model: Listing) {
        listing = model
    }
    
    public func generateModel(forItemAtIndex index: Int) -> ListingDetailsImageCell.Model {
        return ListingDetailsImageCell.Model(
            imageReference: imageReferences[index],
            description: imageDescriptions[index]
        )
    }
    
    public func viewDidLayoutSubviews() {
        guard !didReload else { return }
        reloadData?()
        didReload = true
    }
    
}
