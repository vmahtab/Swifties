//
//  chattStore.swift
//  wanderhub
//
//  Created by Neha Pinnu on 3/21/24.
//

import UIKit
import Alamofire
import Observation
import Foundation


@Observable
final class ChattStore {
    static let shared = ChattStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
                                     // instances can be created
    private(set) var chatts = [Chatt]()
    private let nFields = Mirror(reflecting: Chatt()).children.count
    
    private let serverUrl = "https://34.172.120.53/"

    func getChatts() {
        guard let apiUrl = URL(string: "\(serverUrl)getimages/") else {
            print("getChatts: bad URL")
            return
        }
        
        AF.request(apiUrl, method: .get).responseData { response in
            guard let data = response.data, response.error == nil else {
                print("getChatts: NETWORKING ERROR")
                return
            }
            if let httpStatus = response.response, httpStatus.statusCode != 200 {
                print("getChatts: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getChatts: failed JSON deserialization")
                return
            }
            let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
            self.chatts = [Chatt]()
            for chattEntry in chattsReceived {
                if (chattEntry.count == self.nFields) {
                    self.chatts.append(Chatt(username: chattEntry[0],
                                             timestamp: chattEntry[1],
                                             imageUrl: chattEntry[2]))
                } else {
                    print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
                }
            }
        }
    }
    
    func postChatt(_ chatt: Chatt, image: UIImage?, videoUrl: URL?) async -> Data? {
        guard let apiUrl = URL(string: "\(serverUrl)postimages/") else {
            print("postChatt: Bad URL")
            return nil
        }
        
        return try? await AF.upload(multipartFormData: { mpFD in
            if let username = chatt.username?.data(using: .utf8) {
                mpFD.append(username, withName: "username")
            }
//            if let username = chatt.timestamp?.data(using: .utf8) {
//                mpFD.append(timestamp, withName: "timestamp")
//            }
            if let jpegImage = image?.jpegData(compressionQuality: 1.0) {
                mpFD.append(jpegImage, withName: "image", fileName: "chattImage", mimeType: "image/jpeg")
            }
        }, to: apiUrl, method: .post).validate().serializingData().value
    }
}
