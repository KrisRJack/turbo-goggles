//
//  NewListingViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/21/22.
//

import UIKit

protocol NewListingNavigationDelegate {
    
}

final class NewListingViewController: UITableViewController {
    
    var photos: ReferenceArray<Data>
    var navigationDelegate: NewListingNavigationDelegate?
    
    init(photos imageData: ReferenceArray<Data>) {
        photos = imageData
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
