//
//  EntryViews.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/9/20.
//

import Foundation
import UIKit

extension EntryViewController {
    
    func setupEntryContentView() {
        view.addSubview(entryContentView)
        
        entryContentView.addSubview(continueButton)
        entryContentView.addSubview(sluLogo)
        
        entryContentView.translatesAutoresizingMaskIntoConstraints = false
        entryContentView.heightAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true
        
        entryContentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        entryContentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        entryContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        setupLogo()
        setupContinueButton()
    }
    
    func setupLogo() {
        sluLogo.translatesAutoresizingMaskIntoConstraints = false
        sluLogo.isUserInteractionEnabled = true
        sluLogo.backgroundColor = .white
        
        sluLogo.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sluLogo.heightAnchor.constraint(equalToConstant: 120).isActive = true
        sluLogo.centerXAnchor.constraint(equalTo: entryContentView.centerXAnchor, constant: 0).isActive = true
        sluLogo.centerYAnchor.constraint(equalTo: entryContentView.centerYAnchor, constant: 0).isActive = true
    }
    
    func setupContinueButton() {
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.isUserInteractionEnabled = true
        continueButton.backgroundColor = .white
        
        continueButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        continueButton.topAnchor.constraint(equalTo: entryContentView.bottomAnchor, constant: -80).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: entryContentView.centerXAnchor).isActive = true
    }
    
}
