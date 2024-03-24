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

@Observable
final class UserHistoryStore {
    
    private let user = User.shared
    
    // TODO: ADD AUTHORIZATION. USE WanderHubID.shared.id TO SEND REQUEST TO BACKEND

    func getHistory(completion: @escaping ([ImageData]?) -> Void) {
        guard let apiUrl = URL(string: "\(serverUrl)get-user-landmark/") else {
            print("getHistory: bad URL")
            completion(nil)
            return
        }
        
        // Create a URLRequest with the API URL
        var request = URLRequest(url: apiUrl)
        
        // Set HTTP Method to GET
        request.httpMethod = "GET"
        
        // Add authorization header
        if let token = UserDefaults.standard.string(forKey: "usertoken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            exit(-1);
        }
        
        // please finish for the love of god @neha T
    }


}
