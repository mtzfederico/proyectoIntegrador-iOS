//
//  changeColorView.swift
//  proyectoIntegrador
//
//  Created by FedeMtz on 07/09/21
//  Copyright © 2021 FedeMtz. All rights reserved. 
// 

import UIKit

class changeColorView: UIViewController {
    
    let colorPicker = UIColorPickerViewController()
    
    var prevColorBox: UIView!
    var selectedColorBox: UIView!
    var pickColorButton: UIButton!
    var applyChangeButton: UIButton!
    
    var isLoading: Bool = false {
        didSet {
            applyChangeButton.setNeedsUpdateConfiguration()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Change Color"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupView()
    }
    
    func setupView() {
        colorPicker.delegate = self
        
        prevColorBox = UIView(frame: .zero)
        prevColorBox.translatesAutoresizingMaskIntoConstraints = false
        prevColorBox.backgroundColor = .systemRed
        prevColorBox.layer.borderColor = UIColor.tertiaryLabel.cgColor
        prevColorBox.layer.borderWidth = 1.0
        
        selectedColorBox = UIView(frame: .zero)
        selectedColorBox.translatesAutoresizingMaskIntoConstraints = false
        selectedColorBox.backgroundColor = .systemRed
        selectedColorBox.layer.borderColor = UIColor.tertiaryLabel.cgColor
        selectedColorBox.layer.borderWidth = 1.0
        
        pickColorButton = UIButton(configuration: .filled())
        pickColorButton.translatesAutoresizingMaskIntoConstraints = false
        pickColorButton.frame = .zero
        pickColorButton.configuration?.buttonSize = .medium
        pickColorButton.configuration?.cornerStyle = .medium
        pickColorButton.layer.cornerRadius = 8.0
        pickColorButton.setTitle("Select Color", for: .normal)
        pickColorButton.addTarget(self, action: #selector(pickColorButtonPressed), for: .touchUpInside)
        
        applyChangeButton = UIButton(configuration: .filled())
        applyChangeButton.translatesAutoresizingMaskIntoConstraints = false
        applyChangeButton.frame = .zero
        applyChangeButton.configuration?.buttonSize = .medium
        applyChangeButton.configuration?.cornerStyle = .medium
        applyChangeButton.layer.cornerRadius = 8.0
        applyChangeButton.setTitle("Apply Change", for: .normal)
        applyChangeButton.addTarget(self, action: #selector(applyChangeButtonPressed), for: .touchUpInside)
        applyChangeButton.configurationUpdateHandler = { button in
            var config = button.configuration
            button.isEnabled = !self.isLoading
            config?.showsActivityIndicator = self.isLoading
            button.configuration = config
        }
        
        view.addSubview(prevColorBox)
        view.addSubview(selectedColorBox)
        view.addSubview(pickColorButton)
        view.addSubview(applyChangeButton)
        
        NSLayoutConstraint.activate([
            prevColorBox.heightAnchor.constraint(equalToConstant: 60),
            prevColorBox.widthAnchor.constraint(equalToConstant: 60),
            prevColorBox.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
            prevColorBox.bottomAnchor.constraint(equalTo: pickColorButton.topAnchor, constant: -10),
            
            selectedColorBox.heightAnchor.constraint(equalToConstant: 60),
            selectedColorBox.widthAnchor.constraint(equalToConstant: 60),
            selectedColorBox.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            selectedColorBox.bottomAnchor.constraint(equalTo: pickColorButton.topAnchor, constant: -10),
            
            pickColorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            pickColorButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90),
            
            applyChangeButton.topAnchor.constraint(equalTo: pickColorButton.bottomAnchor, constant: 70),
            applyChangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
        ])
    }
    
    @objc func pickColorButtonPressed() {
        navigationController?.present(colorPicker, animated: true, completion: nil)
    }
    
    @objc func applyChangeButtonPressed() {
        print("applyChangeButtonPressed")
        
        Task {
            isLoading = true
            do {
                let selectedColor = colorPicker.selectedColor
                try await Networking.shared.changeColor(to: selectedColor)
                prevColorBox.backgroundColor = selectedColor
                prevColorBox.accessibilityLabel = "Current color: \(selectedColor.accessibilityName)"
            } catch(let error) {
                print("[applyChangeButtonPressed] got error: \(error.localizedDescription)")
                
                let alert = UIAlertController(title: "Server Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            isLoading = false
        }
    }
}

extension changeColorView: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        print("color picker dismissed")
        let selectedColor = viewController.selectedColor
        print("selected \(selectedColor.accessibilityName)")
        selectedColorBox.backgroundColor = selectedColor
        selectedColorBox.accessibilityLabel = "Selected color: \(selectedColor.accessibilityName)"
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        
    }
}

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        
        return ((coreImageColor.red * 255).rounded(.down), (coreImageColor.green * 255).rounded(.down), (coreImageColor.blue * 255).rounded(.down), coreImageColor.alpha)
    }
}
