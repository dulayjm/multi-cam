//
//  LibraryViews.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/10/20.
//

import Foundation
import UIKit

// TODO: pontentially change layout of grid
// Vanilla views extension
extension LibraryViewController {
    func setupBackButton() {
        self.view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.isUserInteractionEnabled = true
        backButton.backgroundColor = .white
        backButton.tintColor = .blue
        
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        backButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        
        self.view.bringSubviewToFront(backButton)
    }
    
    func setupSelectButton() {
        self.view.addSubview(selectButton)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.isUserInteractionEnabled = true
        selectButton.backgroundColor = .white
        selectButton.tintColor = .blue
        
        selectButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        selectButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        selectButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        
        self.view.bringSubviewToFront(selectButton)
    }
}

// Datasource Extension
extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        myCell.backgroundColor = UIColor.blue
        return myCell
    }
}

// Delagate Extension
extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
        // select item
    }
}
