//
//  AlarmCell.swift
//  proyectoIntegrador
//
//  Created by FedeMtz on 21/09/21
//  Copyright © 2021 FedeMtz. All rights reserved. 
// 

import UIKit

class AlarmCell: UITableViewCell {

    static let identifier = "AlarmCell"
    private var optionalMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        // label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    private var alarmDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .secondarySystemBackground
        contentView.addSubview(optionalMessageLabel)
        contentView.addSubview(alarmDateLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        optionalMessageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        optionalMessageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        // optionalMessageLabel.trailingAnchor.constraint(equalTo: alarmDateLabel.leadingAnchor, constant: -20).isActive = true
        
        alarmDateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        alarmDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        optionalMessageLabel.text = nil
        alarmDateLabel.text = nil
    }
    
    public func configure(alarm: Alarm) {
        if alarm.optionalMessage == "" {
            optionalMessageLabel.text = "Alarm"
        } else {
            optionalMessageLabel.text = alarm.optionalMessage
        }
        
        alarmDateLabel.text = Functions.shared.getLocalTime(date: alarm.alarmDate)
    }
    
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }*/
}
