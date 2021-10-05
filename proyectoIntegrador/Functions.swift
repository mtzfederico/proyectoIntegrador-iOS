//
//  Functions.swift
//  proyectoIntegrador
//
//  Created by FedeMtz on 14/09/21
//  Copyright © 2021 FedeMtz. All rights reserved. 
// 

import Foundation

class Functions {
    static let shared = Functions()
    
    public func getLocalTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.none //Set date style
        dateFormatter.timeZone = .current
        
        // If 11 hours have passed changed the formatted date style
        let timeSinceLastUpdate = Date().timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate
        if timeSinceLastUpdate > 39600 {
            // dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateStyle = DateFormatter.Style.medium // was short
        }
        
        return dateFormatter.string(from: date)
    }
}
