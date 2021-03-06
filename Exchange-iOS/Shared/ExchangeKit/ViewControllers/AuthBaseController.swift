//
//  AuthViewController.swift
//  Exchange
//
//  Created by Kristopher Jackson on 4/10/22.
//

import UIKit

open class AuthBaseController: UIViewController {
    
    let watermarkImageView: UIImageView = .build { imageView in
        imageView.tintColor = .watermarkColor
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Logo-Icon")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        view.backgroundColor = .white
        view.addSubview(watermarkImageView)
        [watermarkImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         watermarkImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         watermarkImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
         watermarkImageView.widthAnchor.constraint(equalTo: watermarkImageView.heightAnchor),
        ].activate()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (window?.safeAreaInsets.bottom ?? 0 > 0) && !isModal {
            self.view.layer.cornerRadius = 40
            self.view.layer.masksToBounds = true
        }
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (window?.safeAreaInsets.bottom ?? 0 > 0) && !isModal {
            self.view.layer.cornerRadius = 0
            self.view.layer.masksToBounds = true
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (window?.safeAreaInsets.bottom ?? 0 > 0) && !isModal {
            self.view.layer.cornerRadius = 40
            self.view.layer.masksToBounds = true
        }
    }
    
    private func setNavigationController() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        let image = UIImage(systemName: "arrow.left")
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
    }
    
}
