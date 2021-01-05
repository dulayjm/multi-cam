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
    var qrLabels = [String]()
    var qrCSVArray:[Dictionary<String, AnyObject>] =  Array()

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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        setupShareButton()
        
        for i in 1...self.qrLabels.count-1 {
            var dct = Dictionary<String, AnyObject>()
            dct.updateValue(i as AnyObject, forKey: "idx")
            dct.updateValue("\(self.qrLabels[i])" as AnyObject, forKey: "label")
            qrCSVArray.append(dct)
        }
        createCSV(from: qrCSVArray)
    }
    
    // MARK: - Private Methods
    func createCSV(from recArray:[Dictionary<String, AnyObject>]) {
        var csvString = "\("idx"),\("label")\n"
        for dct in recArray {
            csvString = csvString.appending("\(String(describing: dct["idx"]!)) ,\(String(describing: dct["label"]!))\n")
        }

        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("labels.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Wrote to file")
        } catch {
            print("error creating file")
        }
        
       // sample read statement
       do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileURL = path.appendingPathComponent("labels.csv")
            let text2 = try String(contentsOf: fileURL, encoding: .utf8)
            print(text2)
       } catch {
            print("could not read from file")
       }
    }

    // MARK: - Navigation
    @objc func backButtonPressed(_ sender:UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func shareButtonPressed(_ sender:UIButton!) {
        print("button selected")
    }
}
