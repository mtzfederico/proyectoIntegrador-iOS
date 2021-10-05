//
//  ViewController.swift
//  proyectoIntegrador
//
//  Created by FedeMtz on 17/08/21
//  Copyright © 2021 FedeMtz. All rights reserved. 
// 

import UIKit
import os

class ViewController: UIViewController {
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.mtzfederico.unidentifed", category: "Main View")
    
    /*
    var refreshControl: UIRefreshControl!
    var scrollView: UIScrollView!
    var contentView: UIView!
    */
    
    var statusLabel: UILabel!
    var setAlarmButton: UIButton!
    var setTimerButton: UIButton!
    var setReminderButton: UIButton!
    var toggleLightButton: UIButton!
    var changeLightColorButton: UIButton!
    var changeColorSchemeButton: UIButton!
    var aboutPageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Proyecto Integrador"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        askForNotificationsPermission()
        // setupScrollView()
        setupView()
        
        Task {
            statusLabel.text = await Networking.shared.getRoomStatus()
        }
    }
    
    /*
    func setupScrollView() {
        scrollView = UIScrollView(frame: .zero)
        contentView = UIView(frame: .zero)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    */
    
    func setupView() {
        statusLabel = UILabel(frame: .zero)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.numberOfLines = 0
        // statusLabel.text = "Outside Temperature: 30ºC\nRoom Temperature: 23ºC\nDoor Closed"
        statusLabel.text = "Loading"
        
        setAlarmButton = UIButton(configuration: .filled())
        setAlarmButton.translatesAutoresizingMaskIntoConstraints = false
        setAlarmButton.frame = .zero
        setAlarmButton.configuration?.buttonSize = .medium
        setAlarmButton.configuration?.cornerStyle = .medium
        setAlarmButton.layer.cornerRadius = 8.0
        setAlarmButton.setTitle("Set Alarm", for: .normal)
        setAlarmButton.addTarget(self, action: #selector(setAlarmButtonPressed), for: .touchUpInside)
        
        setTimerButton = UIButton(configuration: .filled())
        setTimerButton.translatesAutoresizingMaskIntoConstraints = false
        setTimerButton.frame = .zero
        setTimerButton.configuration?.buttonSize = .medium
        setTimerButton.configuration?.cornerStyle = .medium
        setTimerButton.layer.cornerRadius = 8.0
        setTimerButton.setTitle("Set Timer", for: .normal)
        setTimerButton.addTarget(self, action: #selector(setTimerButtonPressed), for: .touchUpInside)
        
        setReminderButton = UIButton(configuration: .filled())
        setReminderButton.translatesAutoresizingMaskIntoConstraints = false
        setReminderButton.frame = .zero
        setReminderButton.configuration?.buttonSize = .medium
        setReminderButton.configuration?.cornerStyle = .medium
        setReminderButton.layer.cornerRadius = 8.0
        setReminderButton.setTitle("Set Reminder", for: .normal)
        setReminderButton.addTarget(self, action: #selector(setReminderButtonPressed), for: .touchUpInside)
        
        toggleLightButton = UIButton(configuration: .filled())
        toggleLightButton.translatesAutoresizingMaskIntoConstraints = false
        toggleLightButton.frame = .zero
        toggleLightButton.configuration?.buttonSize = .medium
        toggleLightButton.configuration?.cornerStyle = .medium
        toggleLightButton.layer.cornerRadius = 8.0
        toggleLightButton.setTitle("Toggle Light", for: .normal)
        toggleLightButton.addTarget(self, action: #selector(toggleLightButtonPressed), for: .touchUpInside)
        
        changeLightColorButton = UIButton(configuration: .filled())
        changeLightColorButton.translatesAutoresizingMaskIntoConstraints = false
        changeLightColorButton.frame = .zero
        changeLightColorButton.configuration?.buttonSize = .medium
        changeLightColorButton.configuration?.cornerStyle = .medium
        changeLightColorButton.layer.cornerRadius = 8.0
        changeLightColorButton.setTitle("Change Color", for: .normal)
        changeLightColorButton.addTarget(self, action: #selector(changeLightColorButtonPressed), for: .touchUpInside)
        
        changeColorSchemeButton = UIButton(configuration: .plain())
        changeColorSchemeButton.translatesAutoresizingMaskIntoConstraints = false
        changeColorSchemeButton.frame = .zero
        changeColorSchemeButton.backgroundColor = .secondarySystemBackground
        changeColorSchemeButton.layer.cornerRadius = 10.0
        changeColorSchemeButton.setImage(UIImage(systemName: "moon"), for: .normal)
        changeColorSchemeButton.addTarget(self, action: #selector(changeColorSchemeButtonPressed), for: .touchUpInside)
        
        aboutPageButton = UIButton(configuration: .plain())
        aboutPageButton.translatesAutoresizingMaskIntoConstraints = false
        aboutPageButton.frame = .zero
        aboutPageButton.backgroundColor = .secondarySystemBackground
        aboutPageButton.layer.cornerRadius = 10.0
        aboutPageButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        aboutPageButton.addTarget(self, action: #selector(aboutPageButtonPressed), for: .touchUpInside)
        
        view.addSubview(statusLabel)
        view.addSubview(setAlarmButton)
        view.addSubview(setTimerButton)
        view.addSubview(setReminderButton)
        view.addSubview(toggleLightButton)
        view.addSubview(changeLightColorButton)
        view.addSubview(changeColorSchemeButton)
        view.addSubview(aboutPageButton)
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            
            setAlarmButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            setAlarmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            
            setTimerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            setTimerButton.centerYAnchor.constraint(equalTo: setAlarmButton.centerYAnchor, constant: 0),
            
            setReminderButton.topAnchor.constraint(equalTo: setTimerButton.bottomAnchor, constant: 10),
            setReminderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            toggleLightButton.topAnchor.constraint(equalTo: setReminderButton.bottomAnchor, constant: 10),
            toggleLightButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            
            changeLightColorButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            changeLightColorButton.centerYAnchor.constraint(equalTo: toggleLightButton.centerYAnchor, constant: 0),
            
            changeColorSchemeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            changeColorSchemeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            aboutPageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            aboutPageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5
                                                   )
        ])
    }
    
    @objc func setAlarmButtonPressed() {
        let vc = alarmView()
        vc.alarmType = .alarm
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func setTimerButtonPressed() {
        let vc = alarmView()
        vc.alarmType = .timer
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func setReminderButtonPressed() {
        let vc = alarmView()
        vc.alarmType = .reminder
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func toggleLightButtonPressed() {
        let vc = toggleLightView()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func changeLightColorButtonPressed() {
        let vc = changeColorView()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    @objc func pullToRefresh() {
        Task {
            statusLabel.text = await Networking.shared.getRoomStatus()
            refreshControl.endRefreshing()
        }
    }*/
    
    @objc func changeColorSchemeButtonPressed() {
        let scheme = UserDefaults.standard.integer(forKey: "colorScheme")
        let currentSelection = scheme == 0 ? "System" : scheme == 1 ? "Light" : "Dark" // 0 = system, 1 = light, 2 = dark
        let alert = UIAlertController(title: "Select a Style", message: "Current selection: \(currentSelection)", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "System", style: .default , handler:{ _ in
                self.navigationController?.overrideUserInterfaceStyle = .unspecified
                UserDefaults.standard.set(0, forKey: "colorScheme")
                self.navigationController?.reloadInputViews()
            }))
            
            alert.addAction(UIAlertAction(title: "Light", style: .default , handler:{ _ in
                self.navigationController?.overrideUserInterfaceStyle = .light
                UserDefaults.standard.set(1, forKey: "colorScheme")
            }))

            alert.addAction(UIAlertAction(title: "Dark", style: .default , handler:{ _ in
                self.navigationController?.overrideUserInterfaceStyle = .dark
                UserDefaults.standard.set(2, forKey: "colorScheme")
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ _ in}))

            self.present(alert, animated: true, completion: nil)
    }
    
    @objc func aboutPageButtonPressed() {
        let vc = aboutVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: Ask the user for permission for notifications
    func askForNotificationsPermission() {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                self.logger.debug("Notification Permissions granted, sending token to server...")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                
            } else {
                self.logger.error("Notification Permissions denied with error: \(error?.localizedDescription ?? "No error", privacy: .public)")
            }
        }
    }
}

