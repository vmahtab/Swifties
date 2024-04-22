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

import Combine

struct LandmarkVisit : Identifiable, Hashable, Decodable {
    var id: Int
    var landmark_name: String
    var visit_time: String
    var city_name: String
    var country_name: String
    var description: String
    var rating: Int
    var tags: [String]
    var image_url: String?
}

class UserHistoryStore: ObservableObject {
    
    static let shared = UserHistoryStore()
    private init() {}               
    @Published var landmarkVisits = [LandmarkVisit]()
 
    
    func visitedPlaces() -> [LandmarkVisit] {
        return landmarkVisits
    }
    
    
    func getHistory() async {
        // Method implementation
        guard let apiUrl = URL(string: "\(serverUrl)get-user-landmarks/") else {
            print("addUser: Bad URL")
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "usertoken") else {
            return
        }
        
        let headers : HTTPHeaders = [
            "Authorization": "Token \(token)",
            "Content-Type": "application/json; charset=utf-8" ]

        
        AF.request(apiUrl, method: .get, headers: headers).responseData { response in
            //debugPrint(response)
            guard let data = response.data else {
                print("getHistory: No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedLandmarkVisits = try decoder.decode([LandmarkVisit].self, from: data)
                self.landmarkVisits = decodedLandmarkVisits
                //print("Updated landmark visits:", self.landmarkVisits)
            } catch {
                   print("getHistory: Error decoding JSON - \(error)")
                }
                
            }

        }
        
    }
    
