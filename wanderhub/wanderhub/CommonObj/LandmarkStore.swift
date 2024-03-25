//
//  ChattStore.swift
//  swiftUIChatter
//
//  Created by Alexey Kovalenko on 1/22/24.
//

import Foundation
import Observation


final class LandmarkStore: ObservableObject {
    static let shared = LandmarkStore() // create one instance of the class to be shared
    
    // instances can be created
    @Published var landmarks = [Landmark]()
    // TODO: FIXME get rid of this and fix setters and getters
    
    // private constructor (we don't actually want instances of this since dummy data)
    private init() {
        
        self.landmarks.append(contentsOf: [
            
            // Bell Tower
            Landmark(name: "Bell Tower", 
                     message: "Ding Dong",
                     timestamp: "now",
                     geodata: GeoData(lat: 42.2743155694, lon: -83.736413721)),
            
            // UMich
            Landmark(name: "University of Michigan - Ann Arbor", 
                     timestamp: "now",
                     geodata: GeoData(lat:  42.278564, lon: -83.737998)),
            
            // Big House
            Landmark(name: "The Big House", 
                     message: "Hail to The Victors!",
                     timestamp: "now",
                     geodata: GeoData(lat: 42.265649, lon: -83.748443)),
            
            // Arb
            Landmark(name: "Nichols Arboretum", 
                     timestamp: "now",
                     geodata: GeoData(lat: 42.280800, lon: -83.726784))
        ])
    }
    
    private let nFields = Mirror(reflecting: Landmark()).children.count
    
    // FIX the URL TODO: FIXME
//    private let serverUrl = "https://3.22.222.79/"
    
    // TODO: ADD AUTHORIZATION. USE WanderHubID.shared.id TO SEND REQUEST TO BACKEND
    func removeLandmark(index: Int) {
        
        // TODO: Call backend to remove the landmark from the itinerary
        
        
        landmarks.remove(at: index)
    }
    
    // TODO: ADD AUTHORIZATION. USE WanderHubID.shared.id TO SEND REQUEST TO BACKEND
    func getLandmarks() async {
        // FIX THIS
        // TODO: FIXME IMPLEMENT ME
        
        return
        
        //        guard let apiUrl = URL(string: "\(serverUrl)getmaps/") else {
        //            print("getChatts: Bad URL")
        //            return
        //        }
        //
        //        var request = URLRequest(url: apiUrl)
        //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        //        request.httpMethod = "GET"
        //
        //        URLSession.shared.dataTask(with: request) { data, response, error in
        //            guard let data = data, error == nil else {
        //                print("getChatts: NETWORKING ERROR")
        //                return
        //            }
        //            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
        //                print("getChatts: HTTP STATUS: \(httpStatus.statusCode)")
        //                return
        //            }
        //
        //            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
        //                print("getChatts: failed JSON deserialization")
        //                return
        //            }
        //            let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
        //
        //            DispatchQueue.main.async {
        //                self.chatts = [Chatt]()
        //                for chattEntry in chattsReceived {
        //                    if chattEntry.count == self.nFields {
        //                        let geoArr = chattEntry[3]?.data(using: .utf8).flatMap {
        //                            try? JSONSerialization.jsonObject(with: $0) as? [Any]
        //                        }
        //                        self.chatts.append(Chatt(username: chattEntry[0],
        //                                                message: chattEntry[1],
        //                                                timestamp: chattEntry[2],
        //                                                 geodata: geoArr.map {
        //                                                    GeoData(lat: $0[0] as! Double,
        //                                                            lon: $0[1] as! Double,
        //                                                            place: $0[2] as! String,
        //                                                            facing: $0[3] as! String,
        //                                                            speed: $0[4] as! String)
        //                                                 }
        //                        ))
        //                    } else {
        //                        print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
        //                    }
        //                }
        //            }
        //        }.resume()
    }
    
    
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
