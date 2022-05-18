//
//  ListingBaseViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/16/22.
//

import UIKit

final class ListingBaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: "plus.app"),
            selectedImage: UIImage(systemName: "plus.app")
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
