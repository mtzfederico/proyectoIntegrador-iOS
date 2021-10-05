//
//  alarmView.swift
//  proyectoIntegrador
//
//  Created by FedeMtz on 07/09/21
//  Copyright © 2021 FedeMtz. All rights reserved. 
// 

import UIKit

class alarmView: UIViewController {
    
    var datePicker: UIDatePicker!
    var optionalTextField: UITextField!
    var notificationTypeSegmentedControl: UISegmentedControl!
    var submitButton: UIButton!
    
    var refreshControl: UIRefreshControl!
    var tableView: UITableView!
    var tableViewActivityIndicator: UIActivityIndicatorView!
    
    let notificationOptions = ["Notification", "Speech", "Both"]
    
    var alarmsSet: [Alarm] = []
    
    var isLoading: Bool = false {
        didSet {
            submitButton.setNeedsUpdateConfiguration()
        }
    }
    
    var alarmType: AlarmType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Set \(alarmType.displayName)"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupView()
        getAlarms(showActivityIndicator: true)
    }
    
    func setupView() {
        datePicker = UIDatePicker(frame: .zero)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        optionalTextField = UITextField(frame: .zero)
        optionalTextField.translatesAutoresizingMaskIntoConstraints = false
        optionalTextField.clearButtonMode = .whileEditing
        optionalTextField.backgroundColor = .tertiarySystemBackground
        optionalTextField.borderStyle = .roundedRect
        optionalTextField.keyboardType = .numbersAndPunctuation
        optionalTextField.placeholder = "Optional Message"
        
        notificationTypeSegmentedControl = UISegmentedControl(items: notificationOptions)
        notificationTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        notificationTypeSegmentedControl.selectedSegmentIndex = 0
        notificationTypeSegmentedControl.backgroundColor = .secondarySystemBackground
        
        submitButton = UIButton(configuration: .filled())
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.frame = .zero
        submitButton.configuration?.buttonSize = .medium
        submitButton.configuration?.cornerStyle = .medium
        submitButton.layer.cornerRadius = 8.0
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        submitButton.configurationUpdateHandler = { button in
            var config = button.configuration
            button.isEnabled = !self.isLoading
            config?.showsActivityIndicator = self.isLoading
            button.configuration = config
        }
        
        // MARK: Create the sensors table
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmCell.self, forCellReuseIdentifier: AlarmCell.identifier)
        tableView.backgroundColor = .systemBackground
        
        refreshControl = UIRefreshControl()
        // refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableViewActivityIndicator = UIActivityIndicatorView(frame: .zero)
        tableViewActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(datePicker)
        view.addSubview(optionalTextField)
        view.addSubview(notificationTypeSegmentedControl)
        view.addSubview(submitButton)
        view.addSubview(tableView)
        tableView.addSubview(tableViewActivityIndicator)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            
            optionalTextField.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            optionalTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            
            notificationTypeSegmentedControl.topAnchor.constraint(equalTo: optionalTextField.bottomAnchor, constant: 10),
            notificationTypeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            
            submitButton.topAnchor.constraint(equalTo: notificationTypeSegmentedControl.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            
            tableView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            tableViewActivityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            tableViewActivityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
        ])
    }
    
    @objc func submitButtonPressed() {
        Task {
            isLoading = true
            do {
                try await Networking.shared.setAlarm(type: alarmType.rawValue, notificationType: notificationOptions[notificationTypeSegmentedControl.selectedSegmentIndex].lowercased(), date: datePicker.date, optionalMessage: optionalTextField.text ?? "")
            } catch(let error) {
                print("[submitButtonPressed] got error: \(error.localizedDescription)")
                
                let alert = UIAlertController(title: "Server Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            isLoading = false
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        getAlarms(showActivityIndicator: false)
        self.refreshControl.endRefreshing()
    }
    
    func getAlarms(showActivityIndicator: Bool) {
        Task {
            if showActivityIndicator {
                tableViewActivityIndicator.startAnimating()
            }
            do {
                alarmsSet = try await Networking.shared.getAlarms(for: alarmType)
                
                if alarmsSet.isEmpty {
                    tableView.setEmptyMessage(for: alarmType)
                }
                
                tableView.reloadData()
            } catch(let error) {
                print("[getAlarms] got error: \(error.localizedDescription)")
                
                let alert = UIAlertController(title: "Server Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
            if showActivityIndicator {
                tableViewActivityIndicator.stopAnimating()
            }
        }
    }
}


extension alarmView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmsSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmCell.identifier) as! AlarmCell
        cell.configure(alarm: alarmsSet[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

struct getAlarmsResponse: Decodable {
    let alarms: [Alarm]
}

struct Alarm: Decodable {
    var optionalMessage: String?
    var alarmDate: Date
}

enum AlarmType: String {
    case alarm = "alarm"
    case timer = "timer"
    case reminder = "reminder"
    
    var displayName: String {
        switch self {
        case .alarm:
            return "Alarm"
        case .timer:
            return "Timer"
        case .reminder:
            return "Reminder"
        }
    }
}

extension UITableView {
    func setEmptyMessage(for type: AlarmType) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = "No \(type.displayName)s set\nSwipe down to refresh"
        messageLabel.textColor = .secondaryLabel
        // messageLabel.backgroundColor = .secondarySystemBackground
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
    
    func showNoSensorsMessage() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
