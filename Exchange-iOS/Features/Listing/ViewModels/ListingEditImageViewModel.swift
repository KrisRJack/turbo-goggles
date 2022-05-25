//
//  ListingEditImageViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/24/22.
//

import Foundation

final class ListingEditImageViewModel {
    
    public var reloadData: (()-> Void)?
    public var numberOfRowsInSection: Int { images.count }
    
    private var didReload: Bool = false
    private var images: ReferenceArray<ListingImage>
    
    init(images: ReferenceArray<ListingImage>) {
        self.images = images
    }
    
    public func object(at index: Int) -> ListingImage {
        return images.object(at: index)
    }
    
    public func set(text: String?, forObjectAt index: Int) {
        images.modify(at: index) { object in
            object.description = text
        }
    }
    
    public func viewDidLayoutSubviews() {
        guard !didReload else { return }
        reloadData?()
        didReload = true
    }
    
}
