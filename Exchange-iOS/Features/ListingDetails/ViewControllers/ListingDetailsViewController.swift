//
//  ListingDetailsViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/18/22.
//

import UIKit

final class ListingDetailsViewController: UITableViewController {
    
    init(model: Listing) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

