//
//  CameraViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/18/22.
//

import AVFoundation
import UIKit

final class CameraViewModel {
    
    public enum PreviewState {
        case startRunning
        case stopRunning
    }
    
    public struct Camera {
        let captureSession: () -> AVCaptureSession?
        let photoOutput: () -> AVCapturePhotoOutput?
        let sliderValue: () -> Float?
    }

    public var minimumZoomFactor: CGFloat = 1
    public var maximumZoomFactor: CGFloat = 4
    public var cameraPermitted: (() -> Void)?
    public var cameraNotPermitted: (() -> Void)?
    public var error: ((_ string: String) -> Void)?
    public var updateSlider: ((_ value: Float) -> Void)?
    public var didRotateCamera: ((_ position: AVCaptureDevice.Position) -> Void)?
    
    private let cameraListener: Camera!
    private var zoomFactor: CGFloat = 1.0
    private var sliderValue: Float? { cameraListener.sliderValue() }
    private var device: AVCaptureDevice? { AVCaptureDevice.default(for: .video) }
    private var captureSession: AVCaptureSession? { cameraListener.captureSession() }
    private var photoOutput: AVCapturePhotoOutput? { cameraListener.photoOutput() }
    
    init(camera: Camera) {
        cameraListener = camera
    }
    
    /// Inital set up needed to show preview in the camera view
    public func configureCameraPreview() {
        captureSession?.beginConfiguration()
        guard let device = device, let photoOutput = photoOutput else { return }
        do {
            captureSession?.addInput(try AVCaptureDeviceInput(device: device))
            captureSession?.addOutput(photoOutput)
        } catch {
            self.error?(error.localizedDescription)
        }
        captureSession?.commitConfiguration()
    }
    
    /// Start or stop camera preview
    public func cameraPreview(_ state: PreviewState) {
        switch state {
        case .startRunning:
            captureSession?.startRunning()
        case .stopRunning:
            captureSession?.stopRunning()
        }
    }
    
    /// Requests access for using the device's camera
    public func requestCameraPermissionStatus() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] permissionGranted in
            guard let self = self else { return }
            permissionGranted ? self.cameraPermitted?() : self.cameraNotPermitted?()
        }
    }
    
    /// Update the camera zoom factor to the value of the slider 
    public func updateZoomFactorToMatchSliderValue() {
        guard let sliderValue = sliderValue else { return }
        zoomFactor = CGFloat(sliderValue)
        updateZoomFactor(to: sliderValue)
    }
    
    ///  Update zoom factor and slider when pinch state changes
    public func pinchDidUpdate(to state: UIPinchGestureRecognizer.State, scale: CGFloat) {
        let newScaleFactor = minMaxZoom(scale * zoomFactor)
        updateSlider?(Float(newScaleFactor))
        switch state {
        case .began:
            fallthrough
        case .changed:
            updateZoomFactor(to: Float(newScaleFactor))
        case .ended:
            zoomFactor = minMaxZoom(newScaleFactor)
            updateZoomFactor(to: Float(zoomFactor))
        default:
            break
        }
    }
    
    public func flipCamera() {
        guard let session = captureSession else { return }
        guard let input: AVCaptureDeviceInput = session.inputs.first as? AVCaptureDeviceInput else { return }
        
        session.beginConfiguration()
        session.removeInput(input)
        
        var newCamera: AVCaptureDevice!
        if input.device.position == .back {
            didRotateCamera?(.front)
            newCamera = cameraWithPosition(position: .front)
        } else {
            didRotateCamera?(.back)
            newCamera = cameraWithPosition(position: .back)
        }
            
        do {
            let newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            session.addInput(newVideoInput)
        } catch {
            self.error?(error.localizedDescription)
        }

        session.commitConfiguration()
    }
    
    // MARK: - PRIVATE
    
    private func minMaxZoom(_ factor: CGFloat) -> CGFloat {
        min(max(factor, minimumZoomFactor), maximumZoomFactor)
    }
    
    private func updateZoomFactor(to newZoomFactor: Float) {
        guard let device = device else { return }
        do {
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            device.videoZoomFactor = CGFloat(newZoomFactor)
        } catch {
            self.error?(error.localizedDescription)
        }
    }
    
    /// Find a camera with the specified AVCaptureDevicePosition, returns `nil` if one is not found
    private func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: AVMediaType.video,
            position: .unspecified
        )
        
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
}
