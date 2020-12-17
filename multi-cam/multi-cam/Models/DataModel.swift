//
//  LibraryModel.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/11/20.
//

import Foundation
import UIKit

// create some dummy values from xcassets
// TODO: Save images from camera functions

class DataModel {
//    weak var delegate: DataModelDelegate?
    var imageCache = [Int:UIImage]()

    func requestData(image: UIImage) {
        print("here")
        imageCache.updateValue(image, forKey: imageCache.count)
        print(imageCache.count)
//        delegate?.didSendDataUpdate(data: image)
    }
    
    func loadImages() -> [Int:UIImage] {
//        delegate?.didReceiveDataUpdate(data: image)
        print("HERE")
//        delegate?.didSendDataUpdate(self)
        return imageCache
    }
    
}

protocol DataModelDelegate {
    func didSendDataUpdate(data: [Int:UIImage])
}
