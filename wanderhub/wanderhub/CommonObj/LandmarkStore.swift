//
//  ChattStore.swift
//  swiftUIChatter
//
//  Created by Alexey Kovalenko on 1/22/24.
//

import Foundation
import Observation

struct NearestLandmark: Hashable, Decodable {
    var distance: Double
    var landmark: String
    var latitude: Double
    var longitude: Double
    var tags: [String]
}

struct LandmarkResponse: Decodable {
    var landmarks: [NearestLandmark]
}



final class LandmarkStore: ObservableObject {
    static let shared = LandmarkStore() // create one instance of the class to be shared
    
   // @ObservedObject var userItineraryStore = UserItineraryStore.shared
    // this is for the nearest locations
    @Published var nearest = [NearestLandmark]()
    
    // instances can be created
    @Published var landmarks = [Landmark]()
    

    private init() {
        Task {
            await getNearest()
            // fix this later
        //    await getLandmarks(day: 1)
        }
   }
    
    private let nFields = Mirror(reflecting: Landmark()).children.count
    
    // FIX the URL TODO: FIXME
//    private let serverUrl = "https://3.22.222.79/"
    
    // TODO: ADD AUTHORIZATION. USE WanderHubID.shared.id TO SEND REQUEST TO BACKEND
    func removeLandmark(landmark: newLandmark) async {
        
        // TODO: Call backend to remove the landmark from the itinerary
        
        landmarks.removeAll{ String($0.id) == String(landmark.item_id) }
        
        let jsonObj = ["id": landmark.item_id]
        print(jsonObj)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("addUser: jsonData serialization error")
            return
        }
        guard let token = UserDefaults.standard.string(forKey: "usertoken") else {
            return
        }
        guard let apiUrl = URL(string:  "\(serverUrl)remove-from-itinerary/") else {
            print("remove landmarks: bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("removeLandmark: HTTP STATUS: \(httpStatus.statusCode)")
                print("Response:")
                print(response)
                return
            }
            print("Response:")
            print(response)
            

        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }

    }
    
    
    
    
    
    func submitRating(rating: Int, id: String) async {
        var landmark2Rate = landmarks.first { $0.id == id }
        landmark2Rate?.rating = rating
        //make a post request to rate the landmark
        
        let jsonObj = ["landmark_name": landmark2Rate?.name as Any,
                       "new_rating": rating] as [String : Any]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("addUser: jsonData serialization error")
            return
        }
        
        guard let apiUrl = URL(string: "\(serverUrl)testing_update_landmark_rating/") else { // TODO REPLACE URL
            print("addUser: Bad URL")
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "usertoken") else {
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
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("submit rating: HTTP STATUS: \(httpResponse.statusCode)")
                print("Response:")
                print(response)
                return
            }

        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }

        
        
    }
    
    func getNearest() async {
        
        let parameters: [String: Any] = [
            "longitude": LocManager.shared.location.coordinate.longitude,
            "latitude": LocManager.shared.location.coordinate.latitude,
            "distance": 10
        ]
        
        guard let token = UserDefaults.standard.string(forKey: "usertoken") else {
            return
        }
        print(token)
        guard let apiUrl = URL(string: "\(serverUrl)get-nearby-landmarks/") else {
            print("get nearby landmarks: bad url")
            return
        }
        
        
        do {
            
            let jsonBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            var request = URLRequest(url: apiUrl)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
            request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.httpBody = jsonBody
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("get upcoming trips: HTTP STATUS: \(httpStatus.statusCode)")
                print("Response:")
                print(response)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let landmarksArray = jsonObject["landmarks"] as? [[String: Any]] else {
                    print("Failed to parse JSON data")
                    return
                }
              //  print(landmarksArray)
                
                let decodedLandmarks = try landmarksArray.map { landmarkDict in
                    return try JSONDecoder().decode(NearestLandmark.self, from: JSONSerialization.data(withJSONObject: landmarkDict))
                }
             //   print(decodedLandmarks)
                
                DispatchQueue.main.async {
                    self.nearest = decodedLandmarks
                }
                //print(self.nearest)
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
            
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        
        return
        
        
    }
    
//    func getLandmarksDay(day: Int?) async {
//        await getLandmarks(day: 1)
//    }

//    func getLandmarks(day: Int?) async {
//        guard let apiUrl = URL(string: "\(serverUrl)get_landmarks/") else {
//            print("addUser: Bad URL")
//            return
//        }
//        guard let token = UserDefaults.standard.string(forKey: "usertoken") else {
//            print("no token found in memory")
//            return
//        }
//        
//        var request = URLRequest(url: apiUrl)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
//        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "GET"
//        
//        do {
//            
//            let (data, response) = try await URLSession.shared.data(for: request)
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                print("getLandmarks: HTTP STATUS: \(httpStatus.statusCode)")
//                print("Response:")
//                print(response)
//                return
//            }
//            print("Response:")
//            print(response)
//
//        } catch {
//            print("Error: \(error.localizedDescription)")
//            return
//        }
//
//
//
//        return
//        
//        //        guard let apiUrl = URL(string: "\(serverUrl)getmaps/") else {
//        //            print("getChatts: Bad URL")
//        //            return
//        //        }
//        //
//        //        var request = URLRequest(url: apiUrl)
//        //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
//        //        request.httpMethod = "GET"
//        //
//        //        URLSession.shared.dataTask(with: request) { data, response, error in
//        //            guard let data = data, error == nil else {
//        //                print("getChatts: NETWORKING ERROR")
//        //                return
//        //            }
//        //            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//        //                print("getChatts: HTTP STATUS: \(httpStatus.statusCode)")
//        //                return
//        //            }
//        //
//        //            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
//        //                print("getChatts: failed JSON deserialization")
//        //                return
//        //            }
//        //            let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
//        //
//        //            DispatchQueue.main.async {
//        //                self.chatts = [Chatt]()
//        //                for chattEntry in chattsReceived {
//        //                    if chattEntry.count == self.nFields {
//        //                        let geoArr = chattEntry[3]?.data(using: .utf8).flatMap {
//        //                            try? JSONSerialization.jsonObject(with: $0) as? [Any]
//        //                        }
//        //                        self.chatts.append(Chatt(username: chattEntry[0],
//        //                                                message: chattEntry[1],
//        //                                                timestamp: chattEntry[2],
//        //                                                 geodata: geoArr.map {
//        //                                                    GeoData(lat: $0[0] as! Double,
//        //                                                            lon: $0[1] as! Double,
//        //                                                            place: $0[2] as! String,
//        //                                                            facing: $0[3] as! String,
//        //                                                            speed: $0[4] as! String)
//        //                                                 }
//        //                        ))
//        //                    } else {
//        //                        print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
//        //                    }
//        //                }
//        //            }
//        //        }.resume()
//    }
    
    
    // TODO: ADD AUTHORIZATION. USE WanderHubID.shared.id TO SEND REQUEST TO BACKEND
    func postLandmark(_ landmark: Landmark, completion: @escaping () -> ()) async {
        
        // TODO: FIXME IMPLEMENT ME
        return
        //        var geoObj: Data?
        //        if let geodata = chatt.geodata {
        //            geoObj = try? JSONSerialization.data(withJSONObject: [geodata.lat, geodata.lon, geodata.place, geodata.facing, geodata.speed])
        //        }
        //
        //        let jsonObj = ["username": chatt.username,
        //                       "message": chatt.message,
        //                       "geodata": (geoObj == nil) ? nil : String(data: geoObj!, encoding: .utf8)]
        //
        //        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
        //            print("postChatt: jsonData serialization error")
        //            return
        //        }
        //
        //        guard let apiUrl = URL(string: "\(serverUrl)postmaps/") else {
        //            print("postChatt: Bad URL")
        //            return
        //        }
        //
        //        var request = URLRequest(url: apiUrl)
        //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //        request.httpMethod = "POST"
        //        request.httpBody = jsonData
        //
        //        URLSession.shared.dataTask(with: request) { data, response, error in
        //            guard let _ = data, error == nil else {
        //                print("postChatt: NETWORKING ERROR")
        //                return
        //            }
        //
        //            if let httpStatus = response as? HTTPURLResponse {
        //                if httpStatus.statusCode != 200 {
        //                    print("postChatt: HTTP STATUS: \(httpStatus.statusCode)")
        //                    return
        //                } else {
        //                    completion()
        //                }
        //            }
        //
        //        }.resume()
        //    }
        
    }
}
