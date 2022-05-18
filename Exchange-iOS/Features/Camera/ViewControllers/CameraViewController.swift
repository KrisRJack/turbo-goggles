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
    
    public var navigationDelegate: CameraNavigationDelegate?
    private var captureSession: AVCaptureSession = .init()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addPreviewLayerToView()
        requestCameraPermissions()
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
                    self.setUpVideoPreivew()
                    self.captureSession.startRunning()
                }
            } else {
                self.navigationDelegate?.showPermissionMessage(from: self)
            }
        }
    }
    
    private func setUpVideoPreivew() {
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
    
}
