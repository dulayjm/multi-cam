//
//  MainViews.swift
//  multi-cam
//
//  Created by Justin Dulay on 12/9/20.
//

import Foundation
import UIKit

extension MainViewController {
    
    func setupMainContentView() {
        
        view.addSubview(mainContentView)
        
        mainContentView.addSubview(sluLogoLeft)
        mainContentView.addSubview(cameraButton)
        mainContentView.addSubview(lidarButton)
        mainContentView.addSubview(libraryButton)
        
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        mainContentView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        
        mainContentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainContentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        setupLogoLeft()
        setupLidarButton()
        setupLibraryButton()
        setupCameraButton()
    }
    
    func setupLogoLeft() {
        sluLogoLeft.translatesAutoresizingMaskIntoConstraints = false
        sluLogoLeft.isUserInteractionEnabled = true
        sluLogoLeft.backgroundColor = .white
        
        sluLogoLeft.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sluLogoLeft.heightAnchor.constraint(equalToConstant: 60).isActive = true
        sluLogoLeft.leftAnchor.constraint(equalTo: mainContentView.leftAnchor, constant: 30).isActive = true
        sluLogoLeft.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 50).isActive = true
    }
    
    func setupCameraButton() {
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.isUserInteractionEnabled = true
        cameraButton.backgroundColor = .white
        
        cameraButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 180).isActive = true
        cameraButton.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor, constant: 0).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor, constant: -150).isActive = true
    }
    
    func setupLidarButton() {
        lidarButton.translatesAutoresizingMaskIntoConstraints = false
        lidarButton.isUserInteractionEnabled = true
        lidarButton.backgroundColor = .white
        
        lidarButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        lidarButton.heightAnchor.constraint(equalToConstant: 180).isActive = true
        lidarButton.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor, constant: 0).isActive = true
        lidarButton.centerYAnchor.constraint(equalTo: libraryButton.centerYAnchor, constant: -200).isActive = true
    }
    
    func setupLibraryButton() {
        libraryButton.translatesAutoresizingMaskIntoConstraints = false
        libraryButton.isUserInteractionEnabled = true
        libraryButton.backgroundColor = .white
        
        libraryButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        libraryButton.heightAnchor.constraint(equalToConstant: 180).isActive = true
        libraryButton.centerXAnchor.constraint(equalTo: mainContentView.centerXAnchor, constant: 0).isActive = true
        libraryButton.centerYAnchor.constraint(equalTo: mainContentView.centerYAnchor, constant: 250).isActive = true
    }
    
}
