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
        button.addTarget(self, action: #selector(flipCameraPressed), for: .touchUpInside)
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
        slider.tintColor = .systemYellow
        slider.minimumValue = self.viewModel.minimumZoomFactor
        slider.maximumValue = self.viewModel.maximumZoomFactor
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
        
        viewModel.updateSlider = { [weak self] newValue in
            guard let self = self else { return }
            self.slider.value = newValue
        }
        
        viewModel.cameraPermitted = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.slider.setValue(self.viewModel.minimumZoomFactor.halfOf, animated: true)
                self.viewModel.configureCameraPreview()
                self.viewModel.cameraPreview(.startRunning)
            }
        }
        
        viewModel.cameraNotPermitted = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.slider.isUserInteractionEnabled = false
                self.slider.setValue(self.viewModel.maximumZoomFactor.halfOf + 1, animated: true)
                self.navigationDelegate?.showPermissionMessage(from: self)
            }
        }
        
        viewModel.didRotateCamera = { [weak self] position in
            guard let self = self else { return }
            self.slider.isHidden = position == .front
            self.slider.value = Float(self.viewModel.minimumZoomFactor)
            self.viewModel.updateZoomFactorToMatchSliderValue()
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
        viewModel.requestCameraPermissionStatus()
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
    
    @objc private func tapToFocusCamera(_ sender: Any) {
        guard let sender = sender as? UITapGestureRecognizer else { return }
        viewModel.tapToFocusCamera(focusPoint: sender.location(in: view), viewSize: view.frame.size)
    }
    
}
