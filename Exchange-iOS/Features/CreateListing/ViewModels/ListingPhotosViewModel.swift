//
//  ListingPhotosViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/22/22.
//

import Foundation

final class ListingPhotosViewModel: NSObject {
    
    public var imageCount: Int { images.count }
    public var imageArrayIsEmpty: Bool { images.count == .zero }
    
    private var images: ReferenceArray<ListingImage>
    
    init(images imageData: ReferenceArray<ListingImage>) {
        images = imageData
    }
    
    public func item(at index: Int) -> ListingImage {
        return images.object(at: index)
    }
    
    public func deleteItem(at index: Int) {
        _ = images.remove(at: index)
    }
    
    public func insert(item: ListingImage, at index: Int) {
        images.insert(item, at: index)
    }
    
}
