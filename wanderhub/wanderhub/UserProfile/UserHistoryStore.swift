//
//  UserHistoryStore.swift
//  wanderhub
//
//  Created by Neha Tiwari on 3/24/24.
//

import Foundation
import UIKit
import Alamofire
import Observation

struct LandmarkVisit {
    let landmarkName: String
    let visitTime: Date
    let city: String
    let country: String
}

class UserHistoryStore {
    
    //private let user = User.shared
    static let shared = UserHistoryStore()


    func getHistory() async -> [String: Any]? {
        // Method implementation
        guard let apiUrl = URL(string: "\(serverUrl)get-user-landmark") else {
            print("addUser: Bad URL")
            return nil
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "Get"
        //request.httpBody = jsonData
        
        if let token = UserDefaults.standard.string(forKey: "usertoken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            exit(-1);
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("user history error: HTTP STATUS: \(httpStatus.statusCode)")
                return nil
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                return nil
            }
            
            return jsonObj
        } catch {
            print("api dont work yet")
            return nil
        }
        
    }
    
    
    func parseLandmarkVisits(from json: [String: Any]) -> [LandmarkVisit]? {
        guard let visitsArray = json["visits"] as? [[String: Any]] else {
            print("Unable to parse 'visits' array from JSON")
            return nil
        }
        
        var landmarkVisits: [LandmarkVisit] = []
        
        for visitDict in visitsArray {
            guard let landmarkName = visitDict["landmarkName"] as? String,
                  let city = visitDict["city"] as? String,
                  let country = visitDict["country"] as? String,
                  let visitTimeString = visitDict["visitTime"] as? String,
                  let visitTime = ISO8601DateFormatter().date(from: visitTimeString) else {
                print("Incomplete or invalid visit data in JSON")
                continue
            }
            
            let landmarkVisit = LandmarkVisit(landmarkName: landmarkName,
                                              visitTime: visitTime,
                                              city: city,
                                              country: country)
            landmarkVisits.append(landmarkVisit)
        }
        
        return landmarkVisits
        
        
//        let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
//                      self.chatts = [Chatt]()
//                      for chattEntry in chattsReceived {
//                          if (chattEntry.count == self.nFields) {
//                              self.chatts.append(Chatt(username: chattEntry[0],
//                                               message: chattEntry[1],
//                                               timestamp: chattEntry[2],
//                                               imageUrl: chattEntry[3],
//                                               videoUrl: chattEntry[4]))
//                          } else {
//                              print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
//                          }
        
    }
    
    
    
    
}
