//
//  CameraViewController.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/11/20.
//

import Foundation
import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var model = LibraryModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let vc = UIImagePickerController()
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        model.imageCache[-1] = image
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        picker.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
