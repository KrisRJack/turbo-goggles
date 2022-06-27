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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setUpTabBarAppearance() {
        tabBar.isOpaque = true
        tabBar.clipsToBounds = true
        tabBar.backgroundColor = .systemBackground
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundColor = .systemBackground
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        tabBar.standardAppearance = appearance
    }
    
}

extension HomeTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController is ListingTabBarViewController {
            navigationDelegate?.navigateToCreateListing()
            return false
        }
        
        return true
        
    }

}
