//
//  aboutVC.swift
//  proyectoIntegrador
//
//  Created by FedeMtz on 05/10/21
//  Copyright © 2021 FedeMtz. All rights reserved. 
// 

import UIKit
import SafariServices

class aboutVC: UIViewController {
    private var descriptionLabel: UILabel!
    private var openGHPageButton: UIButton!
    private var openAppGHPageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        setupView()
    }
    
    func setupView() {
        descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        
        descriptionLabel.text = """
        This is a voice assistant program with a helper iOS app.
        This program let's you control things with voice and set alarms.

        This program consists of three parts. The voice assistant program, the web server, and the alarm notifier program.

        The voice assistant program (voiceRecognition.py), runs constantly and when it is called it runs the specified action.

        The Web Server (webServer.py), runs constantly and it handles requests from the iOS app.

        The alarm notifier program (checkAlarms.py), runs constantly and checks if an an alarm's alarmTime has already passed and notifies the user via iOS notifications or TTS.
        
        Made by Federico Martinez
        """
        
        openGHPageButton = UIButton(configuration: .filled())
        openGHPageButton.translatesAutoresizingMaskIntoConstraints = false
        openGHPageButton.frame = .zero
        openGHPageButton.configuration?.buttonSize = .medium
        openGHPageButton.configuration?.cornerStyle = .medium
        openGHPageButton.layer.cornerRadius = 8.0
        openGHPageButton.setTitle("Open Github Page", for: .normal)
        openGHPageButton.addTarget(self, action: #selector(openGHPageButtonPressed), for: .touchUpInside)
        
        openAppGHPageButton = UIButton(configuration: .filled())
        openAppGHPageButton.translatesAutoresizingMaskIntoConstraints = false
        openAppGHPageButton.frame = .zero
        openAppGHPageButton.configuration?.buttonSize = .medium
        openAppGHPageButton.configuration?.cornerStyle = .medium
        openAppGHPageButton.layer.cornerRadius = 8.0
        openAppGHPageButton.setTitle("Open App's Github Page", for: .normal)
        openAppGHPageButton.addTarget(self, action: #selector(openAppGHPageButtonPressed), for: .touchUpInside)
        
        view.addSubview(descriptionLabel)
        view.addSubview(openGHPageButton)
        view.addSubview(openAppGHPageButton)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            
            openGHPageButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            openGHPageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            
            openAppGHPageButton.topAnchor.constraint(equalTo: openGHPageButton.bottomAnchor, constant: 10),
            openAppGHPageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
        ])
    }
    
    @objc func openGHPageButtonPressed() {
        guard let url = URL(string: "https://github.com/mtzfederico/proyectoIntegrador") else {
            print("[openGHPageButtonPressed] Invalid url")
            return
        }
        
        let config = SFSafariViewController.Configuration()
        let vc = SFSafariViewController(url: url, configuration: config)
        // vc.overrideUserInterfaceStyle = .dark
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func openAppGHPageButtonPressed() {
        guard let url = URL(string: "https://github.com/mtzfederico/proyectoIntegrador") else {
            print("[openGHPageButtonPressed] Invalid url")
            return
        }
        
        let config = SFSafariViewController.Configuration()
        let vc = SFSafariViewController(url: url, configuration: config)
        // vc.overrideUserInterfaceStyle = .dark
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}
