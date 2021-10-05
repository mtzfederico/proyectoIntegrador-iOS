//
//  Networking.swift
//  proyectoIntegrador
//
//  Created by FedeMtz on 07/09/21
//  Copyright © 2021 FedeMtz. All rights reserved. 
// 

import Foundation
import UIKit

class Networking {
    // static let server = "http://macbook-pro.local:9080"
    static let server = "http://raspberrypi.local:9080"
    
    static let shared = Networking()
    
    static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 40 // seconds
        configuration.timeoutIntervalForResource = 30 // seconds
        // https://stackoverflow.com/questions/23428793/nsurlsession-how-to-increase-time-out-for-url-requests
        
        let session = URLSession(configuration: configuration)
        session.sessionDescription = "Main URLSession"
        return session
    }()
    
    func getRoomStatus() async -> String {
        do {
            let request = URLRequest(url: URL(string: "\(Networking.server)/getRoomStatus")!)
            let (data, _, status) = try await self.request(with: request)
            
            if status == 220 {
                return "Error"
            } else if status != 200 {
                return "Error status is \(status)"
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(roomStatusResponse.self, from: data) else {
                print("[getRoomStatus] bad JSON")
                print("Status: \(status)\nResponse: \(String(decoding: (data), as: UTF8.self))")
                return "Invalid JSON"
            }
            
            return "Outside Temperature: \(decodedResponse.outdoorTemp)ºC\nRoom Temperature: \(decodedResponse.roomTemp)ºC\n\(decodedResponse.doorIsClosed ? "Door is Closed" : "Door is Open")"
            
        } catch(let error) {
            return "Error: \(error.localizedDescription)"
        }
        
    }
    
    func getAlarms(for type: AlarmType) async throws -> [Alarm] {
        let request = URLRequest(url: URL(string: "\(Networking.server)/getAlarms?type=\(type.rawValue)")!)
        let (data, _, status) = try await self.request(with: request)
        
        if status == 220 {
            return []
        } else if status != 200 {
            throw NetworkingErrors.unknownServerError(status: status)
        }
        
        guard let decodedResponse = try? JSONDecoder().decode(getAlarmsResponse.self, from: data) else {
            print("[getAlarms] bad JSON")
            print("Status: \(status)\nResponse: \(String(decoding: (data), as: UTF8.self))")
            throw NetworkingErrors.badJSON
        }
        
        return decodedResponse.alarms

        // return [Alarm(alarmDate: Date(), type: .alarm)]
    }
    
    func changeColor(to color: UIColor) async throws {
        let request = URLRequest(url: URL(string: "\(Networking.server)/changeColor?red=\(color.components.red)&green=\(color.components.green)&blue=\(color.components.blue)&id=1")!)
        let (data, _, status) = try await self.request(with: request)
        
        // if there is an error, throw with the error
        
        print("Response: \(String(decoding: (data), as: UTF8.self))\nStatus: \(status)")
    }
    
    func setAlarm(type: String, notificationType: String, date: Date, optionalMessage: String = "") async throws {
        let bodyData: Data = "type=\(type)&notificationType=\(notificationType)&date=\(date.timeIntervalSince1970)&optionalMessage=\(optionalMessage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!.data(using: .utf8)!
        
        let url = "\(Networking.server)/setAlarm"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        
        let (data, _, status) = try await self.request(with: request)
        
        print("Response: \(String(decoding: (data), as: UTF8.self))\nStatus: \(status)")
        
    }
    
    func request(with reqeust: URLRequest) async throws -> (Data, URLResponse, Int) {
        let (data, response) = try await Networking.session.data(for: reqeust)
        let status = (response as! HTTPURLResponse).statusCode
        
        return (data, response, status)
    }
}

enum NetworkingErrors: Error {
    case badJSON
    case unknownServerError(status: Int)
}

extension NetworkingErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badJSON:
            return NSLocalizedString("The server sent bad JSON", comment: "NetworkingErrors.badJSON's message")
        case .unknownServerError(let status):
            return NSLocalizedString("An unknown server error occurred. Status is \(status)", comment: "NetworkingErrors.unkownServerError's message")
        }
    }
}

struct roomStatusResponse: Decodable {
    let roomTemp: Int
    let outdoorTemp: Float
    let doorIsClosed: Bool
}
