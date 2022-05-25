//
//  ListingCoordinator.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/17/22.
//

import UIKit
import PhotosUI

protocol ListingCoordinatorDelegate {
    func didFinish(from coordinator: ListingCoordinator)
}

final class ListingCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var navigationDelegate: ListingCoordinatorDelegate?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let cameraViewController = CameraViewController()
        cameraViewController.navigationDelegate = self
        navigationController?.viewControllers = [cameraViewController]
    }
    
    private func displayError(withMessage message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Done", style: .default))
        navigationController?.present(alertController, animated: true)
    }
    
}

extension ListingCoordinator: CameraNavigationDelegate {
    
    func showPermissionMessage(from viewController: CameraViewController) {
        let title = NSLocalizedString("CAMERA_DISABLED_HEADER", comment: "Header")
        let message = NSLocalizedString("CAMERA_DISABLED_TEXT", comment: "General")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let dismissActionTitle = NSLocalizedString("DISMISS_BUTTON", comment: "Button")
        let dismissAction = UIAlertAction(title: dismissActionTitle, style: .cancel, handler: { [weak self] action in
            guard let self = self else { return }
            self.navigationDelegate?.didFinish(from: self)
        })
        
        let settingsActionTitle = NSLocalizedString("GO_TO_SETTING_BUTTON", comment: "Button")
        let settingsAction = UIAlertAction(title: settingsActionTitle, style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:]) { completed in
                if completed { self.navigationDelegate?.didFinish(from: self) }
            }
         })
            
        alertController.addAction(settingsAction)
        alertController.addAction(dismissAction)
                                           
        navigationController?.present(alertController, animated: true)
    }
    
    func presentError(from viewController: CameraViewController, withMessage message: String) {
        displayError(withMessage: message)
    }
    
    func dismiss(from viewController: CameraViewController) {
        navigationDelegate?.didFinish(from: self)
    }
    
    func dismiss(from viewController: PHPickerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func showImagePreview(from viewController: CameraViewController, imageData: Data) {
        let imagePreviewController = ImagePreviewViewController(imageData: imageData)
        imagePreviewController.modalTransitionStyle = .crossDissolve
        imagePreviewController.modalPresentationStyle = .fullScreen
        imagePreviewController.delegate = viewController
        imagePreviewController.navigationDelegate = self
        navigationController?.present(imagePreviewController, animated: true)
    }
    
    func goToPhotoLibrary(from viewController: CameraViewController, with configuration: PHPickerConfiguration) {
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = viewController
        pickerViewController.modalPresentationStyle = .fullScreen
        navigationController?.present(pickerViewController, animated: true, completion: nil)
    }
    
    func goToListing(from viewController: CameraViewController, with images: ReferenceArray<ListingImage>) {
        let newListingViewController = NewListingViewController(images: images)
        newListingViewController.navigationDelegate = self
        navigationController?.pushViewController(newListingViewController, animated: true)
    }
    
}

// MARK: - ImagePreviewNavigationDelegate

extension ListingCoordinator: ImagePreviewNavigationDelegate {
    
    func dismiss(from viewController: ImagePreviewViewController) {
        navigationController?.dismiss(animated: true)
    }
    
}

// MARK: - NewListingNavigationDelegate

extension ListingCoordinator: NewListingNavigationDelegate {
    
    func goToGetMedia(from viewController: NewListingViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func goToEditImage(from viewController: NewListingViewController, at indexPath: IndexPath, with images: ReferenceArray<ListingImage>) {
        let editImagesViewController = ListingEditImageViewController(images: images)
        editImagesViewController.navigationDelegate = self
        navigationController?.pushViewController(editImagesViewController, animated: true)
    }
    
}


extension ListingCoordinator: ListingEditImageNavigationDelegate {
    
}
