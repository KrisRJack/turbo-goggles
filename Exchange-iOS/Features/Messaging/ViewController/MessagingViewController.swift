//
//  MessagingViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 6/28/22.
//

import UIKit

final class MessagingViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
}
