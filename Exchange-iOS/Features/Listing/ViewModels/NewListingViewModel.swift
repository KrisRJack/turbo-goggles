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
        guard let user = UserStore.current else {
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
        
        var allImageMetadata: [Listing.ImageMetadata] = []
        images.enumerated().forEach { (index, image) in
            let metadata = Listing.ImageMetadata(id: "\(reference.documentID)_\(index)", description: image.description)
            allImageMetadata.append(metadata)
        }
        
        let listing = Listing(
            id: reference.documentID,
            created: Date(),
            description: formatOptionalString(inputListener.description?()),
            userID: user._id,
            displayName: user.displayName,
            username: user.username,
            header: titleString,
            price: price,
            size: formatOptionalString(inputListener.size?()),
            condition: formatOptionalString(inputListener.condition?()),
            category: formatOptionalString(inputListener.category?()),
            tags: formatTags(string: formatOptionalString(inputListener.tags?())),
            metadata: allImageMetadata
        )
        
        let userReference = DatabaseService.collection(.users).document(user._id)
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
                
                // TODO: Error when uploading images is NOT handled. Currently if images fail to upload, we have a post with no images.
                self.uploadAllImagesToStorage(metadata: allImageMetadata)
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
    
    // Theres a chance that more images will be allowed in the future. Uploading large
    // files from disk is recommended by Firebase, rather than uploading the images directly
    //
    // TODO: Verify that this is actually temporary. If not, remove images when upload completes or interrupted.
    // TODO: This is probably best to do immediatley when capturing from camera or photo library so not hogging memory
    private func temporarilySaveImagesToDisk(metadata: [Listing.ImageMetadata]) throws -> [URL] {
        var urls: [URL] = []
        if let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            for (index, image) in images.enumerated() {
                let imageName = metadata[index].imageName
                let localPath = "\(documentDirectory)/\(imageName)"
                let url = URL(fileURLWithPath: localPath)
                try image.imageData.write(to: url)
                urls.append(url)
            }
        }
        return urls
    }
    
    // TODO: Set stronger rules in Firebase Storage
    private func uploadImageToStorage(fromUrl url: URL, withName name: String, _ completion: @escaping (_ error: Error?) -> Void) {
        let storageReference = StorageService.reference(.market)
        let imageReference = storageReference.child(name)
        imageReference.putFile(from: url, metadata: nil) { _, error in
            completion(error)
        }
    }
    
    private func uploadAllImagesToStorage(metadata: [Listing.ImageMetadata]) {
        do {
            let urls = try temporarilySaveImagesToDisk(metadata: metadata)
            for (index, url) in urls.enumerated() {
                uploadImageToStorage(fromUrl: url, withName: metadata[index].imageName) { error in
                    guard let error = error else { return }
                    self.removeAllFromStorage(metadata: metadata)
                    self.error?(error.localizedDescription)
                    return
                }
            }
        } catch {
            self.error?(error.localizedDescription)
        }
    }
    
    private func removeAllFromStorage(metadata: [Listing.ImageMetadata]) {
        let storageReference = StorageService.reference(.market)
        metadata.forEach { data in
            let itemReference = storageReference.child(data.imageName)
            itemReference.delete()
        }
    }
    
}
