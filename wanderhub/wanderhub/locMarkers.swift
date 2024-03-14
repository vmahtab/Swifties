//
//  ChattStore.swift
//  swiftUIChatter
//
//  Created by Alexey Kovalenko on 1/22/24.
//

import Foundation
import Observation
import MapKit

struct locMarker: Hashable {
    var name: String?
    var message: String?
    var timestamp: String?
    var geodata: GeoData?
}


@Observable
final class locMarkers {
    static let shared = locMarkers() // create one instance of the class to be shared
    private init() {
        self.markers.append(locMarker(name: "Bell Tower", timestamp: "now", geodata: GeoData(lat: 42.2743155694, lon: -83.736413721)))
    }
    private(set) var markers = [locMarker]()
    private let nFields = Mirror(reflecting: locMarker()).children.count

    // replace with good backend
    private let serverUrl = "https://3.22.222.79/"
    
    func getLocMarkers() {
        
        // for Now I will return one default marker that is set on initialization
        // the rest of the code will be unreachable until getMarkers is implemented on backend
        return
        
        // replace with good URL
        guard let apiUrl = URL(string: "\(serverUrl)getmaps/") else {
            print("getChatts: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("getChatts: NETWORKING ERROR")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("getChatts: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getChatts: failed JSON deserialization")
                return
            }
            let locMarkersReceived = jsonObj["chatts"] as? [[String?]] ?? []
            
            DispatchQueue.main.async {
                self.markers = [locMarker]()
                for markerEntry in locMarkersReceived {
                    if markerEntry.count == self.nFields {
                        let geoArr = markerEntry[3]?.data(using: .utf8).flatMap {
                            try? JSONSerialization.jsonObject(with: $0) as? [Any]
                        }
                        self.markers.append(locMarker(name: markerEntry[0],
                                                message: markerEntry[1],
                                                timestamp: markerEntry[2],
                                                 geodata: geoArr.map {
                                                    GeoData(lat: $0[0] as! Double,
                                                            lon: $0[1] as! Double,
                                                            place: $0[2] as! String,
                                                            facing: $0[3] as! String,
                                                            speed: $0[4] as! String)
                                                 }
                        ))
                    } else {
                        print("getChatts: Received unexpected number of fields: \(markerEntry.count) instead of \(self.nFields).")
                    }
                }
            }
        }.resume()
    }
    
    func postLocMarkers(_ locmarker: locMarker, completion: @escaping () -> ()) {
        // this code will be unreachable until backend is implemented for postMarkers
        return
        
        var geoObj: Data?
        if let geodata = locmarker.geodata {
            geoObj = try? JSONSerialization.data(withJSONObject: [geodata.lat, geodata.lon, geodata.place, geodata.facing, geodata.speed])
        }
        
        let jsonObj = ["name": locmarker.name,
                       "message": locmarker.message,
                       "geodata": (geoObj == nil) ? nil : String(data: geoObj!, encoding: .utf8)]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postChatt: jsonData serialization error")
            return
        }
                
        guard let apiUrl = URL(string: "\(serverUrl)postmaps/") else {
            print("postChatt: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                print("postChatt: NETWORKING ERROR")
                return
            }

            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode != 200 {
                    print("postChatt: HTTP STATUS: \(httpStatus.statusCode)")
                    return
                } else {
                    completion()
                }
            }

        }.resume()
    }
    
}
