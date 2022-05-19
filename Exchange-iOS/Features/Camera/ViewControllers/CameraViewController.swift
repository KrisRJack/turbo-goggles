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

    private let closeButtonSize: CGFloat = 32
    private let photosButtonSize: CGFloat = 50
    private let captureButtonSize: CGFloat = 80
    
    private lazy var closeButton: BlurButton = {
        let button = BlurButton(style: .systemUltraThinMaterialLight)
        button.tintColor = .captureButtonColor
        button.cornerRadius = self.closeButtonSize.halfOf
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    private lazy var flipButton: BlurButton = {
        let button = BlurButton(style: .systemUltraThinMaterialLight)
        button.tintColor = .captureButtonColor
        button.cornerRadius = self.closeButtonSize.halfOf
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        return button
    }()
    
    private lazy var flashButton: BlurButton = {
        let button = BlurButton(style: .systemUltraThinMaterialLight)
        button.tintColor = .black
        button.hideBlurView = true
        button.backgroundColor = .systemYellow
        button.cornerRadius = self.closeButtonSize.halfOf
        button.setImage(UIImage(systemName: "bolt.badge.a.fill"), for: .normal)
        return button
    }()
    
    private lazy var slider: UISlider = .build { slider in
        slider.value = 3
        slider.minimumValue = 1
        slider.maximumValue = 4
        slider.tintColor = .systemYellow
        slider.addTarget(self, action: #selector(self.sliderValueChanged), for: .valueChanged)
    }
    
    private lazy var photoLibButton: BlurButton = {
        let button = BlurButton(style: .systemUltraThinMaterialLight)
        button.tintColor = .captureButtonColor
        button.cornerRadius = self.photosButtonSize.halfOf
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        return button
    }()
    
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
    private var zoomFactor: CGFloat = 1.0
    private var captureSession: AVCaptureSession = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addPinchGesture()
        setUpConstraints()
        addPreviewLayerToView()
        requestCameraPermissions()
        configureCaptureButtonTapAnimation()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.barStyle = .default
    }
    
    private func setUpConstraints() {
        view.addSubviews(captureButton, photoLibButton, slider, closeButton, flipButton, flashButton)
        [closeButton.widthAnchor.constraint(equalToConstant: closeButtonSize),
         closeButton.heightAnchor.constraint(equalToConstant: closeButtonSize),
         closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
         closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         
         flipButton.widthAnchor.constraint(equalToConstant: closeButtonSize),
         flipButton.heightAnchor.constraint(equalToConstant: closeButtonSize),
         flipButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
         flipButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
         
         flashButton.widthAnchor.constraint(equalToConstant: closeButtonSize),
         flashButton.heightAnchor.constraint(equalToConstant: closeButtonSize),
         flashButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor),
         flashButton.rightAnchor.constraint(equalTo: flipButton.leftAnchor, constant: -12),
         
         captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         captureButton.widthAnchor.constraint(equalToConstant: captureButtonSize),
         captureButton.heightAnchor.constraint(equalToConstant: captureButtonSize),
         captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
         
         photoLibButton.widthAnchor.constraint(equalToConstant: photosButtonSize),
         photoLibButton.heightAnchor.constraint(equalToConstant: photosButtonSize),
         photoLibButton.centerYAnchor.constraint(equalTo: captureButton.centerYAnchor),
         photoLibButton.trailingAnchor.constraint(equalTo: captureButton.leadingAnchor, constant: -20),
         
         slider.widthAnchor.constraint(equalToConstant: 280),
         slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         slider.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -30),
         
        ].activate()
    }
            
    private func addPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchToZoom(_:)))
        view.addGestureRecognizer(pinchGesture)
    }
    
    private func addPreviewLayerToView() {
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
    }
    
    private func requestCameraPermissions() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] permissionGranted in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if permissionGranted {
                    self.setUpVideoPreview()
                    self.captureSession.startRunning()
                } else {
                    self.navigationDelegate?.showPermissionMessage(from: self)
                }
                self.slider.isUserInteractionEnabled = permissionGranted
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
    
    /// Zoom in the camera when user interacts with the slider
    @objc func sliderValueChanged() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        do {
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            let newZoomFactor = CGFloat(slider.value)
            zoomFactor = newZoomFactor
            device.videoZoomFactor = newZoomFactor
        } catch {
            navigationDelegate?.presentError(from: self, withMessage: error.localizedDescription)
        }
    }
    
    /// Zoom in and out when user pinches screen
    @objc func pinchToZoom(_ sender: Any) {
        guard let pinch = sender as? UIPinchGestureRecognizer else { return}
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        func minMaxZoom(_ factor: CGFloat) -> CGFloat { min(max(factor, 1), 4) }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
            } catch {
                navigationDelegate?.presentError(from: self, withMessage: error.localizedDescription)
            }
        }
        
        let newScaleFactor = minMaxZoom(pinch.scale * self.zoomFactor)
        self.slider.value = Float(newScaleFactor)

        switch pinch.state {
        case .began:
            fallthrough
        case .changed:
            update(scale: newScaleFactor)
        case .ended:
            self.zoomFactor = minMaxZoom(newScaleFactor)
            update(scale: self.zoomFactor)
        default:
            break
        }
        
    }
    
}
