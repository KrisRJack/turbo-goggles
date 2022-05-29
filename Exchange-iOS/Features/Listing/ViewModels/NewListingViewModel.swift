//
//  NewListingViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/28/22.
//

import Foundation

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
    public var shouldEditImages: ((_ indexPath: IndexPath, _ images: ReferenceArray<ListingImage>) -> Void)?
    
    private let images: ReferenceArray<ListingImage>
    
    init(images: ReferenceArray<ListingImage>) {
        self.images = images
    }
    
    public func shouldEditImage(at indexPath: IndexPath) {
        shouldEditImages?(indexPath, images)
    }
    
    public func postButtonPressed() {
        
    }
    
}
