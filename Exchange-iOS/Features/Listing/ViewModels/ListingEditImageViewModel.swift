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
        return images.objects[index]
    }
    
    public func set(text: String?, forObjectAt index: Int) {
        images.objects[index].description = text
    }
    
    public func viewDidLayoutSubviews() {
        guard !didReload else { return }
        reloadData?()
        didReload = true
    }
    
}
