//
//  HomeTabBarController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/15/22.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewControllers = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
