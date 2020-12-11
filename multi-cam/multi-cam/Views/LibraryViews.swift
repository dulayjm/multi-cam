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
    
    func setupShareButton() {
        self.view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.isUserInteractionEnabled = true
        shareButton.backgroundColor = .white
        shareButton.tintColor = .blue
        
        shareButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        shareButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30).isActive = true
        
        self.view.bringSubviewToFront(shareButton)
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
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 5
        cell?.layer.borderColor = UIColor.red.cgColor
        
        selectedItems[indexPath.row] = cell ?? UICollectionViewCell()
        print(selectedItems.count)
    }
    
    // change background color back when user releases touch
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 5
        cell?.layer.borderColor = UIColor.blue.cgColor
        if let value = selectedItems.removeValue(forKey: indexPath.row) {
            print("The value \(value) was removed.")
            print(selectedItems.count)
        }
    }
}
