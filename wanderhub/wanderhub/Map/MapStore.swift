//
//  MapStore.swift
//  wanderhub
//
//  Created by Neha Pinnu on 3/24/24.
//

import UIKit
import Alamofire
import Observation
import Foundation


@Observable
final class MapStore {
    static let shared = MapStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    private(set) var chatts = [MapData]()
    private let nFields = Mirror(reflecting: MapData()).children.count
    
//    private let serverUrl = "https://34.172.120.53/"
    
    func getChatts() {
        guard let apiUrl = URL(string: "\(serverUrl)getchatts/") else {
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
            let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
            
            DispatchQueue.main.async {
                self.chatts = [MapData]()
                for chattEntry in chattsReceived {
                    if chattEntry.count == self.nFields {
                        let geoArr = chattEntry[3]?.data(using: .utf8).flatMap {
                            try? JSONSerialization.jsonObject(with: $0) as? [Any]
                        }
                        self.chatts.append(MapData(username: chattEntry[0],
                                                   timestamp: chattEntry[1],
                                                   geodata: geoArr.map {
                            GeoData(lat: $0[0] as! Double,
                                    lon: $0[1] as! Double,
                                    place: $0[2] as! String,
                                    facing: $0[3] as! String,
                                    speed: $0[4] as! String)
                        }
                                                  ))
                    } else {
                        print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
                    }
                }
            }
        }.resume()
    }
    
    func postChatt(_ mapData: MapData, completion: @escaping () -> ()) {
        var geoObj: Data?
        if let geodata = mapData.geodata {
            geoObj = try? JSONSerialization.data(withJSONObject: [geodata.lat, geodata.lon, geodata.place, geodata.facing, geodata.speed])
        }
        
        let jsonObj = ["username": mapData.username,
                       "timestamp": mapData.timestamp,
                       "geodata": (geoObj == nil) ? nil : String(data: geoObj!, encoding: .utf8)]
        
        guard let apiUrl = URL(string: "\(serverUrl)postmaps/") else {
            print("postChatt: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
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


