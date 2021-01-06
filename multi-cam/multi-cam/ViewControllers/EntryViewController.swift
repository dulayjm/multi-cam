//
//  EntryViewController.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/9/20.
//

import UIKit

class EntryViewController: UIViewController {
    
    // MARK: - Attributes
    let entryContentView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let sluLogo:UIImageView = {
        let logo = UIImage(named: "sluvislab")
        var logoImageView = UIImageView(image: logo)
        return logoImageView
    }()

    // TODO: potentially make this RxSwift
    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.addTarget(
            self,
            action: #selector(continueButtonPressed(_:)),
            for: .touchUpInside)
        return button
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue
        setupEntryContentView()
    }
    
    // MARK: - Navigation
    @objc func continueButtonPressed(_ sender:UIButton!) {
        // TODO: Setup an user authentication system
        let newViewController = MainViewController()
        self.present(newViewController, animated: true, completion: nil)
    }
}
