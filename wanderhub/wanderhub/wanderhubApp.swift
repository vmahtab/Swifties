//
//  wanderhubApp.swift
//  wanderhub
//
//  Created by Vivianna Mahtab on 3/12/24.
//

import SwiftUI

@main
struct wanderhubApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
