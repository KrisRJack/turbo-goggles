//
//  ImagePreviewViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/19/22.
//

import UIKit

protocol ImagePreviewDelegate {
    func didUsePhoto(imageData: Data)
}

protocol ImagePreviewNavigationDelegate {
    func dismiss(from viewController: ImagePreviewViewController)
}

final class ImagePreviewViewController: UIViewController {
    
    var image: UIImage!
    let buttonHeight: CGFloat = 38
    var delegate: ImagePreviewDelegate?
    var navigationDelegate: ImagePreviewNavigationDelegate?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var imageView: UIImageView = .build { imageView in
        imageView.cornerRadius(15)
        imageView.image = self.image
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    lazy var dismissButton: UIButton = .build { button in
        button.backgroundColor = .cameraSecondaryThemeColor
        button.setTitle("Retake", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.cornerRadius(self.buttonHeight.halfOf)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.addTarget(self, action: #selector(self.retakePressed), for: .touchUpInside)
    }
    
    lazy var saveButton: UIButton = .build { button in
        button.backgroundColor = .cameraThemeColor
        button.setTitle("Use Photo", for: .normal)
        button.setTitleColor(.cameraTintColor, for: .normal)
        button.cornerRadius(self.buttonHeight.halfOf)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.addTarget(self, action: #selector(self.usePhotoPressed), for: .touchUpInside)
    }
    
    init(imageData: Data) {
        super.init(nibName: nil, bundle: nil)
        image = UIImage(data: imageData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraints()
        view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setUpConstraints() {
        view.addSubviews(imageView, dismissButton, saveButton)
        [imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,  constant: 8),
         
         dismissButton.widthAnchor.constraint(equalToConstant: 80),
         dismissButton.heightAnchor.constraint(equalToConstant: buttonHeight),
         dismissButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
         dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
         dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
         
         saveButton.widthAnchor.constraint(equalToConstant: 100),
         saveButton.heightAnchor.constraint(equalToConstant: buttonHeight),
         saveButton.centerYAnchor.constraint(equalTo: dismissButton.centerYAnchor),
         saveButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
         saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
         saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ].activate()
    }
    
    @objc private func retakePressed() {
        navigationDelegate?.dismiss(from: self)
    }
    
    @objc private func usePhotoPressed() {
        guard let data = image.jpegData(compressionQuality: .jpegDataCompressionQuality) else { return }
        delegate?.didUsePhoto(imageData: data)
        navigationDelegate?.dismiss(from: self)
    }
    
}
