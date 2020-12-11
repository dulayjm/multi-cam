//
//  MainViewController.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/9/20.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Attributes
    let mainContentView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // move to top left
    let sluLogoLeft:UIImageView = {
        let logo = UIImage(named: "sluvislab")
        var logoImageView = UIImageView(image: logo)
        return logoImageView
    }()
    
    let cameraButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cameraicon"), for: .normal)
        button.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .touchUpInside)
        return button
    }()

    let libraryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Photo Library", for: .normal)
        button.addTarget(
            self,
            action: #selector(libraryButtonPressed),
            for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupMainContentView()
    }
    
    // MARK: - Navigation
    @objc func cameraButtonPressed(_ sender:UIButton!) {
        print("Button tapped")
        let newViewController = CameraViewController()
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @objc func libraryButtonPressed(_ sender:UIButton!) {
        let newViewController = LibraryViewController()
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
