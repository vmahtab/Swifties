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
import SwiftUI

struct LandmarkVisit {
    var landmarkName: String
    var visitTime: String
    var city: String
    var country: String
    var imageUrl: String?
}

class UserHistoryStore {
    
    //private let user = User.shared
    static let shared = UserHistoryStore()
    // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
    // instances can be created
    @State var landmarkVisits = [LandmarkVisit]()
    // private let nFields = Mirror(reflecting: LandmarkVisit()).children.count
    
    
    func getHistory() {
        // Method implementation
        guard let apiUrl = URL(string: "\(serverUrl)get-user-landmark") else {
            print("addUser: Bad URL")
            return
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
        
        AF.request(apiUrl, method: .get).responseData { response in
            guard let data = response.data, response.error == nil else {
                print("getChatts: NETWORKING ERROR")
                return
            }
            if let httpStatus = response.response, httpStatus.statusCode != 200 {
                
                print("user history error: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                return
            }
            
            let visitsArray = jsonObj["visits"] as? [[String?]] ?? []
            self.landmarkVisits = [LandmarkVisit]()
            for visitEntry in visitsArray {
                
                self.landmarkVisits.append(LandmarkVisit(
                    landmarkName: visitEntry[2]!,
                    visitTime: visitEntry[4]!,
                    city: visitEntry[0]!,
                    country: visitEntry[1]!,
                    imageUrl: visitEntry[3]!
                ))
                
                
                
            }
            
        }
        
        
        //        func parseLandmarkVisits(from json: [String: Any]) -> [LandmarkVisit]? {
        //            guard let visitsArray = json["visits"] as? [[String: Any]] else {
        //                print("Unable to parse 'visits' array from JSON")
        //                return nil
        //            }
        //
        //            var landmarkVisits: [LandmarkVisit] = []
        //
        //            for visitDict in visitsArray {
        //                guard let landmarkName = visitDict["landmark_name"] as? String,
        //                      let city = visitDict["city_name"] as? String,
        //                      let country = visitDict["country_name"] as? String,
        //                      let imageUrl = visitDict["image_url"] as? String,
        //                      let visitTimeString = visitDict["visit_time"] as? String,
        //                      let visitTime = ISO8601DateFormatter().date(from: visitTimeString) else {
        //                    print("Incomplete or invalid visit data in JSON")
        //                    continue
        //                }
        //
        //                let landmarkVisit = LandmarkVisit(landmarkName: landmarkName,
        //                                                  visitTime: visitTime,
        //                                                  city: city,
        //                                                  country: country)
        //                landmarkVisits.append(landmarkVisit)
        //            }
        //
        //            return landmarkVisits
        //        }
        
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
