//
//  ColorsViewController.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/24/20.
//

import Foundation
import UIKit

class ColorsViewController : UIViewController {

    // MARK: - Attributes
    var myCollectionView:UICollectionView?
    var colors = [UIColor]()

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

    // MARK: - View Lifecycle
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 120, height: 120)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.allowsMultipleSelection = true
        myCollectionView?.backgroundColor = UIColor.white
        
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
 
        self.view.addSubview(myCollectionView ?? UICollectionView())
        
        setupBackButton()
    }
    
    // MARK: - Private Methods
    
    // MARK: - Navigation
    @objc func backButtonPressed(_ sender:UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
}
