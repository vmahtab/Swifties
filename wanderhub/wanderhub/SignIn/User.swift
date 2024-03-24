//
//  User.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import Foundation
import Observation

// Consider making this an observable object.
// I assumed that we only need to set this up once,
// So there is no need to keep track of this and update views
class User {
    static let shared = User()
    
    // TODO: FIXME change this after backend is connected
    private init(){
        userID = "Default User"
        username = "Traveller"
    }
    
    let userID: String?
    let username: String?
    
    // TODO: For now I hardcoded sign in. connect This to backend
    func signup(username: String?, password: String?) async -> String? {
        return "Welcome to WanderHub"
    }
    
    // TODO: For now I hardcoded sign in. connect This to backend
    func addUser(_ idToken: String?) async -> String? {
            guard let idToken else {
                return nil
            }
        
        // REMOVE THIS ONCE BACKEND IS CONNECTED
        WanderHubID.shared.id = "Traveller"
        WanderHubID.shared.expiration = Date.distantFuture
        return WanderHubID.shared.id
            // print(idToken)
            
//            let jsonObj = ["clientID": "604793800583-otj4ujim5d39t5r6t1ue1u6dc3hem015.apps.googleusercontent.com",
//                        "idToken" : idToken]
                
        let jsonObj = ["clientID": clientID,
                       "idToken" : idToken]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
                print("addUser: jsonData serialization error")
                return nil
            }

            guard let apiUrl = URL(string: "\(serverUrl)adduser/") else {
                print("addUser: Bad URL")
                return nil
            }
            
            var request = URLRequest(url: apiUrl)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("addUser: HTTP STATUS: \(httpStatus.statusCode)")
                    return nil
                }

                guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                    print("addUser: failed JSON deserialization")
                    return nil
                }

                WanderHubID.shared.id = jsonObj["WanderHubID"] as? String
                WanderHubID.shared.expiration = Date()+(jsonObj["lifetime"] as! TimeInterval)
                
                return WanderHubID.shared.id
            } catch {
                print("addUser: NETWORKING ERROR")
                return nil
            }
        }
    
    
}
