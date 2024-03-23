//
//  ChattStore.swift
//  swiftUIChatter
//
//  Created by Alexey Kovalenko on 1/22/24.
//

import Foundation
import Observation
import MapKit

struct locMarker: Hashable {
    var name: String?
    var message: String?
    var timestamp: String?
    var geodata: GeoData?
}
