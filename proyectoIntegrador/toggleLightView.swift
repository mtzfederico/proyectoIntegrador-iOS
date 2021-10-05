//
//  toggleLightView.swift
//  proyectoIntegrador
//
//  Created by FedeMtz on 07/09/21
//  Copyright © 2021 FedeMtz. All rights reserved. 
// 

import UIKit

class toggleLightView: UIViewController {

    var toggle: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Toggle Light"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupView()
    }
    
    func setupView() {
        toggle = UISwitch(frame: .zero)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(toggleChanged), for: .touchUpInside)
        
        view.addSubview(toggle)
        
        NSLayoutConstraint.activate([
            toggle.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            toggle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
        ])
    }
    
    @objc func toggleChanged() {
        print("Toggle is \(toggle.isOn)")
        
        Task {
            toggle.isEnabled = false
            
            let color: UIColor = {
                if toggle.isOn {
                    return UIColor.white
                } else {
                    return UIColor.black
                }
            }()
            
            do {
                try await Networking.shared.changeColor(to: color)
            } catch(let error) {
                print("[toggleChanged] got error: \(error.localizedDescription)")
                
                let alert = UIAlertController(title: "Server Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            toggle.isEnabled = true
        }
    }

}
