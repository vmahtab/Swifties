//
//  ChattStore.swift
//  wanderhub
//
//  Created by Neha Tiwari on 3/22/24.
//

import UIKit
import Alamofire
import Observation
import Foundation

class ImageStore {
    
    //private let user = User.shared
    static let shared = ImageStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
    // instances can be created
    //private(set) var chatts = [ImageData]()
    //private let nFields = Mirror(reflecting: ImageData()).children.count

    
    func postImage(_ imagedata: ImageData, image: UIImage?) async -> String? {
        guard let apiUrl = URL(string: "\(serverUrl)add-user-landmark/") else {
           print("postChatt: Bad URL")
            return nil
        }
        
        if let token = UserDefaults.standard.string(forKey: "usertoken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            return
        }
        
        var landmarkName: String?

        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        if let token = UserDefaults.standard.string(forKey: "usertoken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            return nil
        }
        
        let response = AF.upload(multipartFormData: { mpFD in
            if let usernameData = imagedata.username.data(using: .utf8) {
                mpFD.append(usernameData, withName: "username")
            }
            if let timestampData = imagedata.timestamp.data(using: .utf8) {
                mpFD.append(timestampData, withName: "timestamp")
            }
            if let jpegImage = image?.jpegData(compressionQuality: 1.0) {
                mpFD.append(jpegImage, withName: "image", fileName: "chattImage", mimeType: "image/jpeg")
            }
            if let geoData = imagedata.geoData {
                // Append GeoData fields
                mpFD.append(String(geoData.lat).data(using: .utf8) ?? Data(), withName: "lat")
                mpFD.append(String(geoData.lon).data(using: .utf8) ?? Data(), withName: "lon")
                mpFD.append(geoData.place.data(using: .utf8) ?? Data(), withName: "place")
                mpFD.append(geoData.facing.data(using: .utf8) ?? Data(), withName: "facing")
                mpFD.append(geoData.speed.data(using: .utf8) ?? Data(), withName: "speed")
            }
        }, to: apiUrl, method: .post).validate()
        
        if let data = response.data {
                    if let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
                        landmarkName = jsonObj["landmark_name"] as? String
                    } else {
                        print("Failed to parse JSON response")
                    }
                } else {
                    print("No data received from server")
                }
            
            return landmarkName
     
    }
    
    
    
    
    //
    //
    //    func postImage(_ imagedata: ImageData, image: UIImage?) async -> Data? {
    //        guard let apiUrl = URL(string: "\(serverUrl)add-user-landmark/") else {
    //            print("postChatt: Bad URL")
    //            return nil
    //        }
    //        var request = URLRequest(url: apiUrl)
    //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    //        request.httpMethod = "POST"
    //
    //        if let token = UserDefaults.standard.string(forKey: "usertoken") {
    //            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    //        } else {
    //            exit(-1);
    //        }
    //
    //            let responseData = try await AF.upload(multipartFormData: { mpFD in
    //                if let usernameData = imagedata.username.data(using: .utf8) {
    //                    mpFD.append(usernameData, withName: "username")
    //                }
    //                if let timestampData = imagedata.timestamp.data(using: .utf8) {
    //                    mpFD.append(timestampData, withName: "timestamp")
    //                }
    //                if let jpegImage = image?.jpegData(compressionQuality: 1.0) {
    //                             mpFD.append(jpegImage, withName: "image", fileName: "chattImage", mimeType: "image/jpeg")
    //                         }
    //                if let geoData = imagedata.geoData {
    //                    // Append GeoData fields
    //                    mpFD.append(String(geoData.lat).data(using: .utf8) ?? Data(), withName: "lat")
    //                    mpFD.append(String(geoData.lon).data(using: .utf8) ?? Data(), withName: "lon")
    //                    mpFD.append(geoData.place.data(using: .utf8) ?? Data(), withName: "place")
    //                    mpFD.append(geoData.facing.data(using: .utf8) ?? Data(), withName: "facing")
    //                    mpFD.append(geoData.speed.data(using: .utf8) ?? Data(), withName: "speed")
    //                }
    //                if let jpegImage = image?.jpegData(compressionQuality: 1.0) {
    //                    mpFD.append(jpegImage, withName: "image", fileName: "chattImage", mimeType: "image/jpeg")
    //                }
    //            }, to: apiUrl, method: .post).validate().response() { response in
    //                guard let data = response.data, response.error == nil else {
    //                    print("getChatts: NETWORKING ERROR")
    //                    return
    //                }
    //                if let httpStatus = response.response, httpStatus.statusCode != 200 {
    //
    //                    print("user history error: HTTP STATUS: \(httpStatus.statusCode)")
    //                    return
    //                }
    //
    //                guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
    //                    return
    //                }
    //
    //                }
    //
    //    }
    //
    //
    //
    //    func getImages(completion: @escaping ([ImageData]?) -> Void) {
    //        guard let apiUrl = URL(string: "\(serverUrl)getimages/") else {
    //            print("getImages: bad URL")
    //            completion(nil)
    //            return
    //        }
    //
    //        AF.request(apiUrl, method: .get).responseData { response in
    //            switch response.result {
    //            case .success(let data):
    //                guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
    //                    print("getImages: failed JSON deserialization")
    //                    completion(nil)
    //                    return
    //                }
    //
    //                let imagesReceived = jsonObj["images"] as? [[String?]] ?? []
    //                var images = [ImageData]()
    //                for imageEntry in imagesReceived {
    //                    if imageEntry.count == self.nFields {
    //                        let geoDataString = imageEntry[3] ?? "" // Assuming geoData is at index 3
    //                        let geoData = self.parseGeoData(from: geoDataString)
    //                        let image = ImageData(username: imageEntry[0],
    //                                          timestamp: imageEntry[1],
    //                                          imageUrl: imageEntry[2],
    //                                          geoData: geoData)
    //                        images.append(image)
    //                    } else {
    //                        print("getImages: Received unexpected number of fields: \(imageEntry.count) instead of \(self.nFields).")
    //                    }
    //                }
    //                completion(images)
    //
    //            case .failure(let error):
    //                print("getImages: NETWORKING ERROR - \(error.localizedDescription)")
    //                completion(nil)
    //            }
    //        }
    //    }
    //
    //    // Helper function to parse GeoData from a string
    //    private func parseGeoData(from geoDataString: String?) -> GeoData? {
    //        guard let geoDataString = geoDataString else { return nil }
    //
    //        let components = geoDataString.components(separatedBy: ",")
    //        guard components.count >= 5 else { return nil }
    //
    //        var geoData = GeoData()
    //        if let lat = Double(components[0]), let lon = Double(components[1]) {
    //            geoData.lat = lat
    //            geoData.lon = lon
    //            geoData.place = components[2]
    //            geoData.facing = components[3]
    //            geoData.speed = components[4]
    //            return geoData
    //        } else {
    //            return nil
    //        }
    //    }
    //
    //
    
}
