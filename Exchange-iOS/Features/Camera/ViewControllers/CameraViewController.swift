//
//  CameraViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/17/22.
//

import UIKit
import AVFoundation

protocol CameraNavigationDelegate {
    func showPermissionMessage(from viewController: CameraViewController)
    func presentError(from viewController: CameraViewController, withMessage message: String)
}

final class CameraViewController: UIViewController {
    
    let captureButtonSize: CGFloat = 80
    
    private lazy var captureButton: BlurButton = {
        let button = BlurButton(style: .systemUltraThinMaterialLight)
        button.layer.borderWidth = 5
        button.cornerRadius = self.captureButtonSize.halfOf
        button.layer.borderColor = UIColor.captureButtonColor.cgColor
        return button
    }()
    
    private var capturePhotoOutput: AVCapturePhotoOutput = {
        let capturePhotoOutput = AVCapturePhotoOutput()
        capturePhotoOutput.isHighResolutionCaptureEnabled = true
        return capturePhotoOutput
    }()
    
    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return previewLayer
    }()
    
    public var navigationDelegate: CameraNavigationDelegate?
    private var captureSession: AVCaptureSession = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpConstraints()
        addPreviewLayerToView()
        requestCameraPermissions()
        configureCaptureButtonTapAnimation()
        navigationController?.delegate = self
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func setUpConstraints() {
        view.addSubviews(captureButton)
        [captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         captureButton.widthAnchor.constraint(equalToConstant: captureButtonSize),
         captureButton.heightAnchor.constraint(equalToConstant: captureButtonSize),
         captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ].activate()
    }
    
    private func addPreviewLayerToView() {
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
    }
    
    private func requestCameraPermissions() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] permissionGranted in
            guard let self = self else { return }
            if permissionGranted {
                DispatchQueue.main.async {
                    self.setUpVideoPreview()
                    self.captureSession.startRunning()
                }
            } else {
                self.navigationDelegate?.showPermissionMessage(from: self)
            }
        }
    }
    
    private func setUpVideoPreview() {
        captureSession.beginConfiguration()
        guard let captureDevice: AVCaptureDevice = .default(for: .video) else { return }
        do {
            captureSession.addInput(try AVCaptureDeviceInput(device: captureDevice))
            captureSession.addOutput(capturePhotoOutput)
        } catch {
            navigationDelegate?.presentError(from: self, withMessage: error.localizedDescription)
        }
        captureSession.commitConfiguration()
    }
    
    private func configureCaptureButtonTapAnimation() {
        captureButton.addTarget(self, action: #selector(captureButtonTouchDown), for: .touchDown)
        captureButton.addTarget(self, action: #selector(captureButtonTouchDown), for: .touchDragEnter)
        captureButton.addTarget(self, action: #selector(captureButtonTouchRelease), for: .touchUpInside)
        captureButton.addTarget(self, action: #selector(captureButtonTouchRelease), for: .touchDragExit)
    }
    
    @objc private func captureButtonTouchDown() {
        UIView.animate(withDuration: 0.2) {
            self.captureButton.borderColor = .captureButtonSelectedColor
        }
    }
    
    @objc private func captureButtonTouchRelease() {
        UIView.animate(withDuration: 0.2) {
            self.captureButton.borderColor = .captureButtonColor
        }
    }
    
}

// MARK: - UINavigationControllerDelegate

extension CameraViewController: UINavigationControllerDelegate {
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
}
