//
//  LibraryViewController.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/10/20.
//

import Foundation
import UIKit

class LibraryViewController : UIViewController {
    
    // MARK: - Attributes
    var myCollectionView:UICollectionView?
    var selectedItems = [Int:UICollectionViewCell]()
    var imageCache = [Int:UIImage]()
//    var imageCache = [Int:UIImage]()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.tintColor = .blue
        button.addTarget(
            self,
            action: #selector(backButtonPressed(_:)),
            for: .touchUpInside)
        return button
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share", for: .normal)
        button.tintColor = .blue
        button.addTarget(
            self,
            action: #selector(shareButtonPressed(_:)),
            for: .touchUpInside)
        return button
    }()
    
    private let dataModel = DataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dataModel.delegate = self
//        LibraryViewController.delegate = self
        
        
        
        self.view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 120, height: 120)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.allowsMultipleSelection = true
        myCollectionView?.backgroundColor = UIColor.white
        
        // dummy cache for loading
        // normally grab from model
//        imageCache = loadImagesFromDataModel()
//        imageCache = dataModel.loadImages()
        
//        let logo1 = UIImage(named: "sluvislab")
//        let dog1 = UIImage(named: "dog1")
//        let dog2 = UIImage(named: "dog2")
//        imageCache[0] = logo1
//        imageCache[1] = dog1
//        imageCache[2] = dog2
        
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
 
        self.view.addSubview(myCollectionView ?? UICollectionView())
        
        setupBackButton()
        setupShareButton()
    }
    
    // MARK: - Navigation
    @objc func backButtonPressed(_ sender:UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func shareButtonPressed(_ sender:UIButton!) {
        print("button selected")
    }
}

//extension LibraryViewController: DataModelDelegate {
//    func didSendDataUpdate(data: [Int : UIImage]) {
//        self.imageCache = data
//    }
//}
