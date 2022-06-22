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
    
    private lazy var leftBarButtonItem = UIBarButtonItem(
        image: UIImage(
            systemName: "paperplane",
            withConfiguration: UIImage.SymbolConfiguration(weight: .medium)
        ),
        style: .plain,
        target: self,
        action: nil
    )
    
    private lazy var rightBarButtonItem = UIBarButtonItem(
        image: UIImage(
            systemName: "bag",
            withConfiguration: UIImage.SymbolConfiguration(weight: .medium)
        ),
        style: .plain,
        target: self,
        action: nil
    )
    
    private let logo: UIImageView = .build { imageView in
        let inset: CGFloat = -4
        imageView.tintColor = .darkThemeColor
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Logo-Text")?
            .withAlignmentRectInsets(UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0))
    }
    
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
        configureBarButtonItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBarAppearance()
    }
    
    private func setUpTabBarAppearance() {
        tabBar.clipsToBounds = true
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .systemBackground
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        tabBar.standardAppearance = appearance
    }
    
    private func configureBarButtonItems() {
        navigationItem.titleView = logo
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    private func setUpNavigationBarAppearance() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .systemBackground
        navigationController?.navigationBar.backgroundColor = .systemBackground
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
