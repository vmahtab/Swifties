//
//  SubmitBooking.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import Foundation

struct TravelBooking: Codable {
    var destination: String
    var startDate: Date
    var endDate: Date
}

class TravelBookingService {
    let apiServer = serverUrl
    
    func submitBooking(booking: TravelBooking, completion: @escaping (Bool, Error?) -> Void) {
        guard let url = URL(string: apiServer) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601 // Assuming the server expects dates in ISO 8601 format
            let jsonData = try encoder.encode(booking)
            request.httpBody = jsonData
        } catch {
            completion(false, error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(false, error)
                return
            }
            
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil) // Successfully submitted the booking
            }
        }.resume()
    }
}
