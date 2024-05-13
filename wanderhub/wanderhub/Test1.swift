//
//  Test1.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/25/24.
//

import Foundation
import SwiftUI

struct testView: View {
    
    var body: some View {
        VStack{
            Button {
                Task {
                    await signup(username: "testing567867", password: "testing4567456", email: "testing@gmail.com")
                }
            } label: {
                Text("text me")
            }
        }
    }
    
    
    func signup(username: String?, password: String?, email: String?) async -> String? {
        guard let username else {
            return nil
        }
        guard let password else {
            return nil
        }
        guard let email else {
            return nil
        }
        
        let jsonObj = ["username": username,
                       "password": password,
                       "email": email]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("addUser: jsonData serialization error")
            return nil
        }
        guard let apiUrl = URL(string: "\(serverUrl)signup") else {
            print("addUser: Bad URL")
            return nil
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("addUser: HTTP STATUS: \(httpStatus.statusCode)")
                print("addUser: HTTP STATUS: \(httpStatus.debugDescription)")
                return nil
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                print("task")
            }

            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("addUser: failed JSON deserialization")
                return nil
            }
            
            guard let token = jsonObj["token"] as? String else {
                return nil
            }
            // TODO: implement once ready to store in keychain
            // WanderHubID.shared.id = jsonObj["WanderHubID"] as? String
            UserDefaults.standard.set(token, forKey: "usertoken")
            //self.username = username
            if let httpStatus = response as? HTTPURLResponse {
                print("addUser: HTTP STATUS: \(httpStatus.statusCode)")
                print("addUser: HTTP STATUS: \(httpStatus.debugDescription)")
                return nil
            }
            //to allow the app remember user
            UserDefaults.standard.set(username, forKey: "username")
            return token
        } catch {
            print("Login Networking Error")
            return nil
        }
    }
    
}
