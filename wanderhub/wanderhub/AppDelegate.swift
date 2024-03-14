//
//  AppDelegate.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/13/24.
//

import Foundation
import GoogleMaps

//GMSServices.provideAPIKey("AIzaSyCkVXMqmLO1h9Fc6pbEfyQ2m6fZNl2AN1k")
//GMSPlacesClient.provideAPIKey("AIzaSyCkVXMqmLO1h9Fc6pbEfyQ2m6fZNl2AN1k")

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    GMSServices.provideAPIKey("AIzaSyCkVXMqmLO1h9Fc6pbEfyQ2m6fZNl2AN1k")
    //GMSPlacesClient.provideAPIKey("AIzaSyCkVXMqmLO1h9Fc6pbEfyQ2m6fZNl2AN1k")
    return true
}
