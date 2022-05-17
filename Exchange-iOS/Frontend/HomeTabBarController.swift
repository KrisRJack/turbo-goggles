//
//  HomeTabBarController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import UIKit

protocol HomeTabBarControllerNavigationDelegate {
    func navigateToCreateListing()
}

class HomeTabBarController: UITabBarController {
    
    var navigationDelegate: HomeTabBarControllerNavigationDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewControllers = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setUpTabBarAppearance()
    }
    
    private func setUpTabBarAppearance() {
        let appearance = tabBar.standardAppearance
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        tabBar.standardAppearance = appearance
        tabBar.layer.borderWidth = 0.2
        tabBar.layer.borderColor = UIColor.separator.cgColor
        tabBar.clipsToBounds = true
    }
    
}

extension HomeTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController is ListingViewController {
            navigationDelegate?.navigateToCreateListing()
            return false
        }
        
        return true
        
    }

}
