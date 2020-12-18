//
//  multiSession.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/18/20.
//

import UIKit
import AVFoundation
import Photos

class MultiSession: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // MARK: - Variables
    lazy private var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy private var takePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        return button
    }()
    
    private let photoOutput = AVCapturePhotoOutput()
    private let photoOutput2 = AVCapturePhotoOutput()
    private let photoOutput3 = AVCapturePhotoOutput()
    private var imageCache = [Int:UIImage]()

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        openCamera()
    }
    
    
    // MARK: - Private Methods
    private func setupUI() {
        
        view.addSubviews(backButton, takePhotoButton)
        
        takePhotoButton.makeConstraints(top: nil, left: nil, right: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, topMargin: 0, leftMargin: 0, rightMargin: 0, bottomMargin: 15, width: 80, height: 80)
        takePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        backButton.makeConstraints(top: view.safeAreaLayoutGuide.topAnchor, left: nil, right: view.rightAnchor, bottom: nil, topMargin: 15, leftMargin: 0, rightMargin: 10, bottomMargin: 0, width: 50, height: 50)
    }
    
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
        
        // I don't think a multicamsession can have multipe outputs, confirmed it can't, see vscode file
        // try tomorrow with multiple avsessions
        
        // here look at other devices
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
            
//            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//            cameraLayer.frame = self.view.frame
//            cameraLayer.videoGravity = .resizeAspectFill
//            self.view.layer.addSublayer(cameraLayer)
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
            
//            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//            cameraLayer.frame = self.view.frame
//            cameraLayer.videoGravity = .resizeAspectFill
//            self.view.layer.addSublayer(cameraLayer)
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

        print("number of capture session inputs", captureSession.inputs.count)
        print("number of capture session outputs", captureSession.outputs.count)
        captureSession.startRunning()
        self.setupUI()
    }
    
    @objc private func handleDismiss() {
        DispatchQueue.main.async {
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
    
    // only show preview of the first one first? but save all of them ... ?
    // or have a layer of preview views??
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
//        var img2 = setupSession2(input: "wide")
//        var img3 = setupSession3(input: "ultrawide")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
        let photoPreviewContainer = PhotoPreviewView(frame: self.view.frame)
        photoPreviewContainer.photoImageView.image = previewImage
        self.view.addSubviews(photoPreviewContainer)
    }
    
//    func setupSession2(input: String) -> UIImage {
//        let captureSession = AVCaptureMultiCamSession()
//
//        // I don't think a multicamsession can have multipe outputs, confirmed it can't, see vscode file
//        // try tomorrow with multiple avsessions
//
//        // here look at other devices
//        // builtInWideAngleCamera, builtInUltraWideCamera, builtInTelephotoCamera
//        if let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
//            do {
//                let input = try AVCaptureDeviceInput(device: captureDevice)
//                if captureSession.canAddInput(input) {
//                    captureSession.addInput(input)
//                }
//            } catch let error {
//                print("Failed to set input device with error: \(error)")
//            }
//
//            if captureSession.canAddOutput(photoOutput) {
//                captureSession.addOutput(photoOutput)
//            }
//
//            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//            cameraLayer.frame = self.view.frame
//            cameraLayer.videoGravity = .resizeAspectFill
//            self.view.layer.addSublayer(cameraLayer)
//        }
//
//        print("number of capture session inputs", captureSession.inputs.count)
//        print("number of capture session outputs", captureSession.outputs.count)
//        captureSession.startRunning()
//
//        // anddddd immediately take the photo
//        return UIImage()
//
//    }
    
}

extension AVCapturePhotoCaptureDelegate {
    func photoOutput2(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
//        var img2 = setupSession2(input: "wide")
//        var img3 = setupSession3(input: "ultrawide")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
//        let photoPreviewContainer = PhotoPreviewView(frame: self.view.frame)
//        photoPreviewContainer.photoImageView.image = previewImage
//        self.view.addSubviews(photoPreviewContainer)
    }
    
    func photoOutput3(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
//        var img2 = setupSession2(input: "wide")
//        var img3 = setupSession3(input: "ultrawide")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
//        let photoPreviewContainer = PhotoPreviewView(frame: self.view.frame)
//        photoPreviewContainer.photoImageView.image = previewImage
//        self.view.addSubviews(photoPreviewContainer)
    }
    
}


extension UIView {
    
    func makeConstraints(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, topMargin: CGFloat, leftMargin: CGFloat, rightMargin: CGFloat, bottomMargin: CGFloat, width: CGFloat, height: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topMargin).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftMargin).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -rightMargin).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomMargin).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach{ addSubview($0) }
    }
}

class PhotoPreviewView: UIView {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy private var savePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        button.addTarget(self, action: #selector(handleSavePhoto), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private let dataModel = DataModel()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        addSubviews(photoImageView, cancelButton, savePhotoButton)
        
        photoImageView.makeConstraints(top: topAnchor, left: leftAnchor, right: rightAnchor, bottom: bottomAnchor, topMargin: 0, leftMargin: 0, rightMargin: 0, bottomMargin: 0, width: 0, height: 0)
        
        cancelButton.makeConstraints(top: safeAreaLayoutGuide.topAnchor, left: nil, right: rightAnchor, bottom: nil, topMargin: 15, leftMargin: 0, rightMargin: 10, bottomMargin: 0, width: 50, height: 50)
        
        savePhotoButton.makeConstraints(top: nil, left: nil, right: cancelButton.leftAnchor, bottom: nil, topMargin: 0, leftMargin: 0, rightMargin: 5, bottomMargin: 0, width: 50, height: 50)
        savePhotoButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func handleCancel() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
    @objc private func handleSavePhoto() {
        
        guard let previewImage = self.photoImageView.image else { return }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .authorized {
                do {
                    try PHPhotoLibrary.shared().performChangesAndWait {
                        // comment out this next line if you don't want to save to camera row
                        PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
                        print("photo has saved in library...")
                        self.handleCancel()
                    }
                } catch let error {
                    print("failed to save photo in library: ", error)
                }
            } else {
                print("Something went wrong with permission...")
            }
        }
    }
}
