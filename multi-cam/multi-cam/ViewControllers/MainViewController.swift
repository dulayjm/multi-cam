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
    let sluLogo:UIImageView = {
        let logo = UIImage(named: "sluvislab")
        var logoImageView = UIImageView(image: logo)
        return logoImageView
    }()

//    // TODO: potentially make this RxSwift
//    let continueButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Continue", for: .normal)
//        button.addTarget(
//            self,
//            action: #selector(continueButtonPressed),
//            for: UIControl.Event.touchUpInside)
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
//        setupMainContentView()
    }
    
//    // MARK: - Navigation
//    @objc func continueButtonPressed(_ sender:UIButton!) {
//        print("Button tapped")
//        // load to next screen
//
//    }
}
