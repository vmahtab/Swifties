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
    var city: String
    var country: String
    var interests: String
}

class TravelBookingService {
    let apiServer = serverUrl
    
    func submitBooking(booking: TravelBooking, completion: @escaping (Bool, Error?) -> Void) async {
        
        guard let apiUrl = URL(string: "\(serverUrl)make-custom-itinerary/") else {
            print("addUser: Bad URL")
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "usertoken") else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let jsonObj = ["city_name": booking.city,
                       "country_name": booking.country,
                       "start_date": dateFormatter.string(from: booking.startDate),
                       "end_date": dateFormatter.string(from: booking.endDate),
        ] as [String : String]
        print(jsonObj)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postChatt: jsonData serialization error")
            return
        }
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        do {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getLandmarks: HTTP STATUS: \(httpStatus.statusCode)")
                print("Response:")
                print(response)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Failed to parse JSON data")
                    return
                }
                print(jsonObject)
//                guard let tripData = jsonObject["itinerary_id"] as? [[String: Any]] else {
//                    print("Failed to parse JSON data")
//                    return
//                }
//                print(tripData)
//                
             
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
            
            
            
        }
        
        
    }

