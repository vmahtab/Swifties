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


@Observable
final class ImageStore {
    
    private let user = User.shared
    static let shared = ImageStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
   // private(set) var chatts = [ImageData]()
    
    // TODO: ADD AUTHORIZATION. USE WanderHubID.shared.id TO SEND REQUEST TO BACKEND
    func postImage(_ imagedata: ImageData, image: UIImage?) async -> Data? {
        guard let apiUrl = URL(string: "\(serverUrl)post_landmark_id_and_info/") else {
            print("postChatt: Bad URL")
            return nil
        }
        
        guard let token = UserDefaults.standard.string(forKey: "usertoken") else {
            return nil
        }
        //        let plainString = token as NSString
        //        let plainData = plainString.data(using:NSUTF8StringEncoding)
        //        let base64String = plainData?.base64EncodedData(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        
        let headers : HTTPHeaders = [
            "Authorization": "Token \(token)",
            "Accept": "application/json; charset=utf-8",
            "Content-Type": "application/json; charset=utf-8" ]

        return try? await AF.upload(multipartFormData: { mpFD in
            if let usernameData = imagedata.username?.data(using: .utf8) {
                mpFD.append(usernameData, withName: "username")
            }
            if let timestampData = imagedata.timestamp?.data(using: .utf8) {
                mpFD.append(timestampData, withName: "timestamp")
            }
            if let geoData = imagedata.geoData {
                // Append GeoData fields
                mpFD.append(String(geoData.lat).data(using: .utf8) ?? Data(), withName: "lat")
                mpFD.append(String(geoData.lon).data(using: .utf8) ?? Data(), withName: "lon")
                mpFD.append(geoData.place.data(using: .utf8) ?? Data(), withName: "place")
                mpFD.append(geoData.facing.data(using: .utf8) ?? Data(), withName: "facing")
                mpFD.append(geoData.speed.data(using: .utf8) ?? Data(), withName: "speed")
            }
            if let image = image?.jpegData(compressionQuality: 1.0) {
                mpFD.append(image, withName: "image", fileName: "chattImage", mimeType: "image/jpeg")
            }
            
            
        }, to: apiUrl, method: .post, headers: headers )
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { response in
            debugPrint(response)
            if let httpResponse = response.response {
                print("Status Code: \(httpResponse.statusCode)")
                print("Headers:")
                for (header, value) in httpResponse.allHeaderFields {
                    print("\(header): \(value)")
                }
            }
            
        }).validate().serializingData().value
        
    }
    
   
}
