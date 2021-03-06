//
//  CameraViewController.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/17/22.
//

import UIKit
import AVFoundation
import PhotosUI

protocol CameraNavigationDelegate {
    func dismiss(from viewController: CameraViewController)
    func dismiss(from viewController: PHPickerViewController)
    func showPermissionMessage(from viewController: CameraViewController)
    func goToListing(from viewController: CameraViewController, with images: ReferenceArray<ListingImage>)
    func showImagePreview(from viewController: CameraViewController, imageData: Data)
    func presentError(from viewController: CameraViewController, withMessage message: String)
    func goToPhotoLibrary(from viewController: CameraViewController, with configuration: PHPickerConfiguration)
}

final class CameraViewController: UIViewController {

    private let closeButtonSize: CGFloat = 32
    private let photosButtonSize: CGFloat = 50
    private let captureButtonSize: CGFloat = 80
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var closeButton: BlurButton = {
        let button = BlurButton(style: .systemUltraThinMaterialLight)
        button.tintColor = .cameraSecondaryThemeColor
        button.cornerRadius = self.closeButtonSize.halfOf
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var flipButton: BlurButton = {
        let button = BlurButton(style: .systemUltraThinMaterialLight)
        button.tintColor = .cameraSecondaryThemeColor
        button.cornerRadius = self.closeButtonSize.halfOf
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        button.addTarget(self, action: #selector(flipCameraPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var flashButton: BlurButton = {
        let button = BlurButton(style: .systemUltraThinMaterialLight)
        button.cornerRadius = self.closeButtonSize.halfOf
        button.addTarget(self, action: #selector(flashModePressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var continueButton: LabelIconBlurButton = {
        let view = LabelIconBlurButton(style: .systemUltraThinMaterialLight)
        view.cornerRadius(12)
        view.tintColor = .cameraSecondaryThemeColor
        view.clipsToBounds = true
        view.titleLabel.textAlignment = .center
        view.imageView.image = UIImage(systemName: "chevron.right")
        view.titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        view.titleLabel.text = NSLocalizedString("CONTINUE_BUTTON", comment: "Button")
        view.imageView.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 16, weight: .bold))
        view.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        return view
    }()
    
    private lazy var slider: UISlider = .build { slider in
        slider.tintColor = .cameraThemeColor
        slider.minimumValue = self.viewModel.minimumZoomFactor
        slider.maximumValue = self.viewModel.maximumZoomFactor
        slider.addTarget(self, action: #selector(self.sliderValueChanged), for: .valueChanged)
    }
    
    private lazy var photoLibButton: BlurButton = {
        let button = BlurButton(style: .systemUltraThinMaterialLight)
        button.tintColor = .cameraSecondaryThemeColor
        button.cornerRadius = self.photosButtonSize.halfOf
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        button.addTarget(self, action: #selector(didTapPhotoLibraryButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var captureButton: BlurButton = {
        let button = BlurButton(style: .systemUltraThinMaterialLight)
        button.layer.borderWidth = 5
        button.cornerRadius = self.captureButtonSize.halfOf
        button.layer.borderColor = UIColor.cameraSecondaryThemeColor.cgColor
        button.addTarget(self, action: #selector(didTapCaptureButton), for: .touchUpInside)
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
    
    public var viewModel: CameraViewModel!
    public var navigationDelegate: CameraNavigationDelegate?
    private var captureSession: AVCaptureSession = .init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let camera = CameraViewModel.Camera(
            captureSession: { [weak self] in
                self?.captureSession
            }, photoOutput: { [weak self] in
                self?.capturePhotoOutput
            }, sliderValue: { [weak self] in
                self?.slider.value
            }
        )
        
        viewModel = CameraViewModel(camera: camera)
        
        viewModel.error = { [weak self] error in
            guard let self = self else { return }
            self.navigationDelegate?.presentError(from: self, withMessage: error)
        }
        
        viewModel.goToPhotoLibrary = { [weak self] in
            guard let self = self else { return }
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = self.viewModel.imageSelectionLimit
            self.navigationDelegate?.goToPhotoLibrary(from: self, with: configuration)
        }
        
        viewModel.didCaptureImage = { [weak self] imageData in
            guard let self = self else { return }
            self.navigationDelegate?.showImagePreview(from: self, imageData: imageData)
        }
        
        viewModel.continueButtonIsHidden = { [weak self] isHidden in
            guard let self = self else { return }
            self.continueButton.isHidden = isHidden
        }
        
        viewModel.updateSlider = { [weak self] newValue in
            guard let self = self else { return }
            self.slider.value = newValue
        }
        
        viewModel.cameraPermitted = { [weak self] in
            guard let self = self else { return }
            self.slider.setValue(self.viewModel.minimumZoomFactor, animated: true)
        }
        
        viewModel.cameraNotPermitted = { [weak self] in
            guard let self = self else { return }
            self.slider.isUserInteractionEnabled = false
            self.slider.setValue((self.viewModel.maximumZoomFactor + 1).halfOf, animated: true)
            self.navigationDelegate?.showPermissionMessage(from: self)
        }
        
        viewModel.didRotateCamera = { [weak self] position in
            guard let self = self else { return }
            self.slider.isHidden = position == .front
            self.slider.value = Float(self.viewModel.minimumZoomFactor)
        }
        
        viewModel.setFlashMode = { [weak self] flashMode in
            guard let self = self else { return }
            switch flashMode {
            case .on:
                self.flashButton.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
            case .off:
                self.flashButton.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
            default:
                self.flashButton.setImage(UIImage(systemName: "bolt.badge.a.fill"), for: .normal)
            }
            self.flashButton.hideBlurView = flashMode == .auto
            self.flashButton.tintColor = flashMode == .auto ? .cameraTintColor : .cameraSecondaryThemeColor
            self.flashButton.backgroundColor = flashMode == .auto ? .cameraThemeColor : .clear
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addViewGestures()
        setUpConstraints()
        addPreviewLayerToView()
        configureCaptureButtonTapAnimation()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if window?.safeAreaInsets.bottom ?? 0 > 0 {
            view.layer.cornerRadius = 30
            view.layer.masksToBounds = true
        }
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if window?.safeAreaInsets.bottom ?? 0 > 0 {
            self.view.layer.cornerRadius = 0
            self.view.layer.masksToBounds = true
        }
        viewModel.cameraPreview(.startRunning)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if window?.safeAreaInsets.bottom ?? 0 > 0 {
            view.layer.cornerRadius = 30
            view.layer.masksToBounds = true
        }
        viewModel.cameraPreview(.stopRunning)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setUpConstraints() {
        view.addSubviews(captureButton, photoLibButton, slider, closeButton, flipButton, flashButton, continueButton)
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
         
         continueButton.trailingAnchor.constraint(equalTo: flipButton.trailingAnchor),
         continueButton.topAnchor.constraint(equalTo: flipButton.bottomAnchor, constant: 20),
        ].activate()
    }
            
    private func addViewGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToFocusCamera(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchToZoom(_:)))
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(pinchGesture)
    }
    
    private func addPreviewLayerToView() {
        videoPreviewLayer.frame = view.layer.bounds
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
    }
    
    private func configureCaptureButtonTapAnimation() {
        captureButton.addTarget(self, action: #selector(captureButtonTouchDown), for: .touchDown)
        captureButton.addTarget(self, action: #selector(captureButtonTouchDown), for: .touchDragEnter)
        captureButton.addTarget(self, action: #selector(captureButtonTouchRelease), for: .touchUpInside)
        captureButton.addTarget(self, action: #selector(captureButtonTouchRelease), for: .touchDragExit)
    }
    
    @objc private func closeButtonPressed() {
        navigationDelegate?.dismiss(from: self)
    }
    
    @objc private func captureButtonTouchDown() {
        UIView.animate(withDuration: 0.2) {
            self.captureButton.alpha = 0.2
        }
    }
    
    @objc private func captureButtonTouchRelease() {
        UIView.animate(withDuration: 0.2) {
            self.captureButton.alpha = 1
        }
    }
    
    @objc private func sliderValueChanged() {
        viewModel.updateZoomFactorToMatchSliderValue()
    }
    
    @objc private func pinchToZoom(_ sender: Any) {
        guard let pinch = sender as? UIPinchGestureRecognizer else { return }
        viewModel.pinchDidUpdate(to: pinch.state, scale: pinch.scale)
    }
    
    @objc private func flipCameraPressed() {
        viewModel.flipCamera()
    }
    
    @objc private func flashModePressed() {
        viewModel.flashModeTapped()
    }
    
    @objc private func tapToFocusCamera(_ sender: Any) {
        guard let sender = sender as? UITapGestureRecognizer else { return }
        viewModel.tapToFocusCamera(focusPoint: sender.location(in: view), viewSize: view.frame.size)
    }
    
    @objc private func didTapCaptureButton() {
        viewModel.didTapCaptureButton()
    }
    
    @objc private func didTapPhotoLibraryButton() {
        viewModel.didTapPhotoLibraryButton()
    }
    
    @objc private func continueButtonPressed() {
        navigationDelegate?.goToListing(from: self, with: viewModel.savedPhotos())
    }
    
}

// MARK: - ImagePreviewDelegate

extension CameraViewController: ImagePreviewDelegate {
    
    func didUsePhoto(imageData: Data) {
        viewModel.saveImage(data: imageData)
    }
    
}

// MARK: - PHPickerViewControllerDelegate

extension CameraViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.navigationDelegate?.dismiss(from: picker)
        self.viewModel.picker(picker, didFinishPicking: results)
    }
    
}
