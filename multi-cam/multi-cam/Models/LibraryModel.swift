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

struct LibraryModel {
    var imageCache = [Int:UIImage]()
    let logo1 = UIImage(named: "sluvislab")
    let dog1 = UIImage(named: "dog1")
    let dog2 = UIImage(named: "dog2")

//    imageCache[0] = logo1 ?? UIImage()
//    imageCache[1] = dog1
//    imageCache[2] = dog2
}

