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
    
    private var images: ReferenceArray<Data>
    
    init(imageData: ReferenceArray<Data>) {
        images = imageData
    }
    
    public func item(at index: Int) -> Data {
        return images.objects[index]
    }
    
    public func deleteItem(at index: Int) {
        _ = images.remove(at: index)
    }
    
    public func insert(item: Data, at index: Int) {
        images.insert(item, at: index)
    }
    
}
