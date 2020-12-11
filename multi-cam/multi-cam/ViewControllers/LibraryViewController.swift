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
    
    let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share", for: .normal)
        button.setTitle("Selected", for: .selected)
        button.tintColor = .blue
        button.addTarget(
            self,
            action: #selector(selectButtonPressed(_:)),
            for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 120, height: 120)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
    
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
 
        self.view.addSubview(myCollectionView ?? UICollectionView())
        
        setupBackButton()
        setupSelectButton()
    }
    
    // MARK: - Navigation
    @objc func backButtonPressed(_ sender:UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectButtonPressed(_ sender:UIButton!) {
        print("button selected")
    }
}
