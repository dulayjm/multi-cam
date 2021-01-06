//
//  CameraViewController.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/18/20.
//

import UIKit
import AVFoundation
import Photos

var imageCache = [Int:UIImage]()
var qrCodeLabelTextGrouping = [String]()

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: - Attributes
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var takePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        return button
    }()
    
    lazy var timerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleTimerSelection), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var colorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.addTarget(self, action: #selector(handleColorSelection), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private let photoOutput = AVCapturePhotoOutput()
    private let photoOutput2 = AVCapturePhotoOutput()
    private let photoOutput3 = AVCapturePhotoOutput()
    var callback : (([Int:UIImage], [String])->())?
    var colorCube = ColorCube()
    var extractedColors = [UIColor]()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        openCamera()
    }
    
    // MARK: - Private Methods
    private func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // the user has already authorized to access the camera.
            self.setupCaptureSession()
            
        case .notDetermined: // the user has not yet asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted { // if user has granted to access the camera.
                    print("the user has granted to access the camera")
                    DispatchQueue.main.async {
                        self.setupCaptureSession()
                    }
                } else {
                    print("the user has not granted to access the camera")
                    self.handleDismiss()
                }
            }
            
        case .denied:
            print("the user has denied previously to access the camera.")
            self.handleDismiss()
            
        case .restricted:
            print("the user can't give camera access due to some restriction.")
            self.handleDismiss()
            
        default:
            print("something has wrong due to we can't access the camera.")
            self.handleDismiss()
        }
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureMultiCamSession()
        
        // builtInWideAngleCamera, builtInUltraWideCamera, builtInTelephotoCamera
        if let captureDevice = AVCaptureDevice.default(.builtInTelephotoCamera, for: AVMediaType.video, position: .back) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch let error {
                print("Failed to set input device with error: \(error)")
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
        }
        
        if let captureDevice2 = AVCaptureDevice.default(.builtInUltraWideCamera, for: AVMediaType.video, position: .back) {
            do {
                let input2 = try AVCaptureDeviceInput(device: captureDevice2)
                if captureSession.canAddInput(input2) {
                    captureSession.addInput(input2)
                }
            } catch let error {
                print("Failed to set input device with error: \(error)")
            }
            
            if captureSession.canAddOutput(photoOutput2) {
                captureSession.addOutput(photoOutput2)
            }
        }
        
        if let captureDevice3 = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            do {
                let input3 = try AVCaptureDeviceInput(device: captureDevice3)
                if captureSession.canAddInput(input3) {
                    captureSession.addInput(input3)
                }
            } catch let error {
                print("Failed to set input device with error: \(error)")
            }
            
            if captureSession.canAddOutput(photoOutput3) {
                captureSession.addOutput(photoOutput3)
            }
            
            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraLayer.frame = self.view.frame
            cameraLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(cameraLayer)
        }

        // Initialize a AVCaptureMetadataOutput object and set it as the input device
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
              
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        print("number of capture session inputs", captureSession.inputs.count)
        print("number of capture session outputs", captureSession.outputs.count)
        captureSession.startRunning()
        self.setupUI()
    }
    
    @objc private func handleDismiss() {
        DispatchQueue.main.async {
            self.callback?(imageCache, qrCodeLabelTextGrouping)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handleTakePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
            photoOutput2.capturePhoto(with: photoSettings, delegate: self)
            photoOutput3.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    @objc func handleTimerSelection() {
        var _ = Timer.scheduledTimer(timeInterval: 2.0,
          target: self,
          selector: #selector(timerCalled),
          userInfo: nil,
          repeats: true)
    }
    
    @objc private func timerCalled() {
        handleTakePhoto()
    }
    
    @objc private func handleColorSelection() {
        let colorsVC = ColorsViewController()
        colorsVC.colors = self.extractedColors
        
        self.present(colorsVC, animated:true, completion: nil)
    }
    
    // Delegate Method - metadata attributes
    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            if let outputString = metadataObj.stringValue {
                DispatchQueue.main.async {
                    print(outputString)
                    qrCodeLabelTextGrouping.append(outputString)
                    let alertVC = UIAlertController()
                    alertVC.title = outputString
                    self.present(alertVC, animated: false, completion: nil)
                    alertVC.modalPresentationStyle = .overFullScreen
                    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    alertVC.removeFromParent()
                    alertVC.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
}

// Extended delegate to handle multiple different outputs on the same instance
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
        extractedColors = colorCube.extractBrightColors(from: previewImage ?? UIImage(), avoid: .blue, count: 4) as! [UIColor]
        
        imageCache.updateValue(previewImage ?? UIImage(), forKey: imageCache.count)

        // default photo capture on the button
        let photoPreviewContainer = PhotoPreviewView(frame: self.view.frame)
        photoPreviewContainer.photoImageView.image = previewImage
        self.view.addSubviews(photoPreviewContainer)
    }
    
    func photoOutput2(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        imageCache.updateValue(previewImage ?? UIImage(), forKey: imageCache.count)
    }
    
    func photoOutput3(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        imageCache.updateValue(previewImage ?? UIImage(), forKey: imageCache.count)
    }
}
