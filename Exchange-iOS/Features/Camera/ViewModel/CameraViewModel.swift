//
//  CameraViewModel.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/18/22.
//

import AVFoundation
import PhotosUI
import UIKit

final class CameraViewModel: NSObject {
    
    public enum PreviewState {
        case startRunning
        case stopRunning
    }
    
    public struct Camera {
        let captureSession: () -> AVCaptureSession?
        let photoOutput: () -> AVCapturePhotoOutput?
        let sliderValue: () -> Float?
    }

    public var maxNumberOfImages: Int = 10
    public var minimumZoomFactor: Float = 1
    public var maximumZoomFactor: Float = 4
    public var cameraPermitted: (() -> Void)?
    public var goToPhotoLibrary: (() -> Void)?
    public var cameraNotPermitted: (() -> Void)?
    public var error: ((_ string: String) -> Void)?
    public var updateSlider: ((_ value: Float) -> Void)?
    public var didCaptureImage: ((_ imageData: Data) -> Void)?
    public var continueButtonIsHidden: ((_ hide: Bool) -> Void)?
    public var setFlashMode: ((_ flashMode: AVCaptureDevice.FlashMode) -> Void)?
    public var didRotateCamera: ((_ position: AVCaptureDevice.Position) -> Void)?
    public var imageSelectionLimit: Int { max(0, maxNumberOfImages - images.count) }
    
    private let images: ReferenceArray<ListingImage> = .init([])
    
    private var zoomFactor: CGFloat!
    private let cameraListener: Camera!
    private var sliderValue: Float? { cameraListener.sliderValue() }
    private var device: AVCaptureDevice? { AVCaptureDevice.default(for: .video) }
    private var captureSession: AVCaptureSession? { cameraListener.captureSession() }
    private var photoOutput: AVCapturePhotoOutput? { cameraListener.photoOutput() }
    
    private var flashMode: AVCaptureDevice.FlashMode = .auto {
        willSet { setFlashMode?(newValue) }
    }
    
    init(camera: Camera) {
        cameraListener = camera
        zoomFactor = CGFloat(minimumZoomFactor)
        super.init()
        images.willUpdate = { newArray in
            self.continueButtonIsHidden?(newArray.count == .zero)
        }
    }
    
    public func viewDidLoad() {
        flashMode = .auto
        images.set(to: [])
        requestCameraPermissionStatus()
    }
    
    public func savedPhotos() -> ReferenceArray<ListingImage> {
        return images
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
            #if !targetEnvironment(simulator)
            captureSession?.startRunning()
            #endif
            break
        case .stopRunning:
            #if !targetEnvironment(simulator)
            captureSession?.stopRunning()
            #endif
            break
        }
    }
    
    /// Requests access for using the device's camera
    public func requestCameraPermissionStatus() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] permissionGranted in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if permissionGranted {
                    self.cameraPermitted?()
                    self.configureCameraPreview()
                } else {
                    self.cameraNotPermitted?()
                }
            }
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
    
    public func flashModeTapped() {
        flashMode = AVCaptureDevice.FlashMode(rawValue: (flashMode.rawValue + 1) % 3) ?? .auto
    }
    
    public func flipCamera() {
        guard let session = captureSession else { return }
        guard let input: AVCaptureDeviceInput = session.inputs.first as? AVCaptureDeviceInput else { return }
        
        session.beginConfiguration()
        session.removeInput(input)
        
        var newCamera: AVCaptureDevice!
        didRotateCamera?(input.device.position == .back ? .front : .back)
        updateZoomFactorToMatchSliderValue()
        newCamera = cameraWithPosition(position: input.device.position == .back ? .front : .back)
            
        do {
            let newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            session.addInput(newVideoInput)
        } catch {
            self.error?(error.localizedDescription)
        }

        session.commitConfiguration()
    }
    
    public func tapToFocusCamera(focusPoint: CGPoint, viewSize size: CGSize) {
        guard let device = device else { return }
        let focusScaledPointX = focusPoint.x / size.width
        let focusScaledPointY = focusPoint.y / size.height
        if device.isFocusModeSupported(.autoFocus) && device.isFocusPointOfInterestSupported {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.focusMode = .continuousAutoFocus
                device.exposureMode = .continuousAutoExposure
                device.focusPointOfInterest = CGPoint(x: focusScaledPointX, y: focusScaledPointY)
                device.exposurePointOfInterest = CGPoint(x: focusScaledPointX, y: focusScaledPointY)
            } catch {
                self.error?(error.localizedDescription)
            }
        }
    }
    
    public func didTapCaptureButton() {
        if imageSelectionLimit > .zero {
            guard let photoOutput = photoOutput else { return }
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.flashMode = flashMode
            photoSettings.isHighResolutionPhotoEnabled = false
            #if !targetEnvironment(simulator)
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
            #endif
        } else {
            error?(NSLocalizedString("MAX_IMAGE_ALERT_MESSAGE", comment: "Alert Message"))
        }
    }
    
    public func didTapPhotoLibraryButton() {
        imageSelectionLimit > .zero
        ? goToPhotoLibrary?()
        : error?(NSLocalizedString("MAX_IMAGE_ALERT_MESSAGE", comment: "Alert Message"))
    }
    
    public func saveImage(data: Data) {
        images.add(ListingImage(imageData: data))
    }
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        _ = results.map({
            $0.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let error = error {
                        self.error?(error.localizedDescription)
                        return
                    }
                    guard let image = image as? UIImage, let data = image.jpegData(compressionQuality: .jpegDataCompressionQuality) else { return }
                    self.saveImage(data: data)
                }
            }
        })
    }
    
    // MARK: - PRIVATE
    
    private func minMaxZoom(_ factor: CGFloat) -> CGFloat {
        let minimum = CGFloat(minimumZoomFactor)
        let maximum = CGFloat(maximumZoomFactor)
        return min(max(factor, minimum), maximum)
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

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            self.error?(error.localizedDescription)
            return
        }
        guard let data = photo.fileDataRepresentation() else { return }
        didCaptureImage?(data)
    }
    
}
