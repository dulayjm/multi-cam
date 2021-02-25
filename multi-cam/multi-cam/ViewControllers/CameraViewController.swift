//
//  CameraViewController.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/18/20.
//

import AVFoundation
import CoreGraphics
import Foundation
import Photos
import QuartzCore
import UIKit

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
    let captureSession = AVCaptureMultiCamSession()
    var shouldCaptureSessionRun = true
    var catchImage:UIImage?
    var counts = 0
    
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

        // builtInWideAngleCamera, builtInUltraWideCamera, builtInTelephotoCamera
        if let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if self.captureSession.canAddInput(input) {
                    self.captureSession.addInput(input)
                }
            } catch let error {
                print("Failed to set input device with error: \(error)")
            }
            
            if self.captureSession.canAddOutput(photoOutput) {
                self.captureSession.addOutput(photoOutput)
            }
        }
        
        if let captureDevice2 = AVCaptureDevice.default(.builtInUltraWideCamera, for: AVMediaType.video, position: .back) {
            do {
                let input2 = try AVCaptureDeviceInput(device: captureDevice2)
                if self.captureSession.canAddInput(input2) {
                    self.captureSession.addInput(input2)
                }
            } catch let error {
                print("Failed to set input device with error: \(error)")
            }
            
            if self.captureSession.canAddOutput(photoOutput2) {
                self.captureSession.addOutput(photoOutput2)
            }
        }
        
        if let captureDevice3 = AVCaptureDevice.default(.builtInTelephotoCamera, for: AVMediaType.video, position: .back) {
            do {
                let input3 = try AVCaptureDeviceInput(device: captureDevice3)
                if self.captureSession.canAddInput(input3) {
                    self.captureSession.addInput(input3)
                }
            } catch let error {
                print("Failed to set input device with error: \(error)")
            }
            
            if self.captureSession.canAddOutput(photoOutput3) {
                self.captureSession.addOutput(photoOutput3)
            }
            
            let cameraLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            cameraLayer.frame = self.view.frame
            cameraLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(cameraLayer)
        }

        // Initialize a AVCaptureMetadataOutput object and set it as the input device
        let captureMetadataOutput = AVCaptureMetadataOutput()
        self.captureSession.addOutput(captureMetadataOutput)
              
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        print("number of capture session inputs", self.captureSession.inputs.count)
        print("number of capture session outputs", self.captureSession.outputs.count)
        self.captureSession.startRunning()
        self.setupUI()
    }
    
    @objc private func handleDismiss() {
        DispatchQueue.main.async {
            self.callback?(imageCache, qrCodeLabelTextGrouping)
            self.dismiss(animated: false, completion: nil)
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
        let _ = Timer.scheduledTimer(timeInterval: 1.0,
          target: self,
          selector: #selector(timerCalled),
          userInfo: nil,
          repeats: true)
    }
    
    @objc private func timerCalled(timer: Timer) {
        counts += 1
        handleTakePhoto()
        
        if counts >= 10 {

            let url = URL(string: "https://dulayjm@hopper.slu.edu:5000/")
            let session = URLSession.shared
            let boundary = UUID().uuidString
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            let retreivedImage: UIImage? = imageCache[0] // TODO: change here for adding more programmatically
            
            let imageData = retreivedImage!.jpegData(compressionQuality: 1)
            if (imageData == nil) {
                print("UIImageJPEGRepresentation return nil")
                return
            }

            var body = Data()
            let paramName = "paramName" // TODO: fill in programaticlaly
            let fileName = "img.jpeg"
            // Add the image data to the raw http request data
            body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(imageData!)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

            request.httpBody = body
                        
            // Send a POST request to the URL, with the data we created earlier
            session.uploadTask(with: request, from: body, completionHandler: { responseData, response, error in
                if error == nil {
                    let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                    if let json = jsonData as? [String: Any] {
                        print(json)
                    }
                }
            }).resume()

            // after sending, delete the images there
            imageCache = [Int:UIImage]()
            // exit the timer mode
            timer.invalidate()
        }
    }
    
    @objc private func handleColorSelection() {
        let colorsVC = ColorsViewController()
        colorsVC.colors = self.extractedColors
        
        self.present(colorsVC, animated:true, completion: nil)
    }
    
    // MARK: - Delegate Method - metadata attributes
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
                                
                // ******************************************************************
                // compute greenness score
                
                handleTakePhoto()
                
                guard let image = self.catchImage else {return}
                guard let cgImage = self.catchImage?.cgImage else { return }

                let width = Int(cgImage.width)
                let height = Int(cgImage.height)
                
                let bitmapBytesPerRow = width
                let cap = cgImage.bytesPerRow * cgImage.height
                let pixelData = UnsafeMutablePointer<UInt8>.allocate(capacity: cap)
                let colorSpace3: CGColorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
                let context = CGContext(data: pixelData, width: cgImage.width, height: cgImage.height, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: cgImage.bytesPerRow, space: colorSpace3, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) // wow!
//                By generating an UnsafeMutablePointer with Pixels (we already know that they are composed of RGB values, as well as an Alpha multiplier), we can manipulate CGContext with information about the size and bitmap (32-bit, big endian format).
                let rect = CGRect(
                    origin: CGPoint(x: 0, y: 0),
                    size: CGSize(width: width, height: height) // maybe switch to width and height from above
                )
                context?.draw(cgImage, in: rect, byTiling: false)
                print("the context is: ", context)

                let numberOfComponents = colorSpace3.numberOfComponents + 1;
                var totalGreenGreaterThanRed = 0
                var i = 0
                
                while i < cap {
                    let red = pixelData[i]
                    let green = pixelData[i+1]
                    let blue = pixelData[i+2]
                    let alpha = pixelData[i+3]
                
                    if green > red {
                        totalGreenGreaterThanRed+=1
                    }
                    
                    i += 4
                }
                print("green greater than red", totalGreenGreaterThanRed)
                // ******************************************************************

                // Stop current capture session from slowing down frame with AV inputs
                self.captureSession.stopRunning()
                
                DispatchQueue.main.async {
                    print(outputString)
                    qrCodeLabelTextGrouping.append(outputString)
                                        
                    let newViewController = LidarViewController()
                    self.present(newViewController, animated: true, completion: nil)
                    
                    // Restart the capture session - writen data still persists
                    self.captureSession.startRunning()
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
        self.catchImage = previewImage
        
        // default photo capture on the button
//        let photoPreviewContainer = PhotoPreviewView(frame: self.view.frame)
//        photoPreviewContainer.photoImageView.image = previewImage
//        self.view.addSubviews(photoPreviewContainer)
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

// MARK: - Green pixel extractor
extension UIImage {
    func getGreenScore(pos: CGPoint) -> Int {
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)

        if g>r {
            return 1
        }
        
        else {
            return -1
        }
    }
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
