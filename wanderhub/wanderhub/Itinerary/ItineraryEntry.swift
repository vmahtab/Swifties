//
//  ItineraryEntry.swift
//  wanderhub
//
//  Created by Vivianna Mahtab on 3/22/24.
//

import Foundation
import SwiftUI

// TODO: temporarily here, move this somewhere more sensible
struct Landmark: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    // what other fields are necessary globally? we could have a single fetch call for all data..?
}

class ItineraryEntries: ObservableObject {
    
    @Published var entries: [Landmark] = [
        Landmark(name: "Eiffel Tower"),
        Landmark(name: "Louvre"),
        Landmark(name: "Notre Dame"),
        Landmark(name: "Arc de Triomphe"),
        Landmark(name: "Palace of Versailles")
    ]
}
