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
    var name: String? // this should probably not be an optional
    var message: String?
    var timestamp: String?
    var geodata: GeoData?
    // what other fields are necessary globally? we could have a single fetch call for all data..?
    
    var favorite: Bool = false
}

