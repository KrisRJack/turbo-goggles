//
//  Coodinator.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/18/22.
//

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    init(navigationController: UINavigationController)
    func start()
}
