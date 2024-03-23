//
//  wanderhubApp.swift
//  wanderhub
//
//  Created by Hasan Zengin on 3/12/24.
//

import SwiftUI

@main
struct wanderhubApp: App {
    init() {
        LocManager.shared.startUpdates()
        LandmarkStore.shared.getLandmarks()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
