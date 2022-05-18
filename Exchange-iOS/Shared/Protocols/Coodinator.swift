//
//  Coodinator.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 4/18/22.
//

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController? { get }
    init(_ navigationController: UINavigationController)
    func start()
}
