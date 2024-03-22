////
////  ItineraryEntry.swift
////  wanderhub
////
////  Created by Vivianna Mahtab on 3/17/24.
////
//
//import Foundation
//import Observation
//import SwiftUI
//
//// TODO: temporarily here, move this somewhere more sensible
//struct Landmark: Identifiable, Hashable {
//    let name: String?
//    let id: Int?
//    
//    // what other fields are necessary globally? we could have a single fetch call for all data..?
//}
//
//@Observable
//final class ItineraryEntry {
//    
//    static let staticItinerary = ItineraryEntries() // create one instance of the class to be shared
//    private(set) var entries = [Landmark]()
//    
//    // TODO: we should be able to generate this - static population makes me sad .-.
//    private init() {
//        
//        self.entries.append(contentsOf: [
//            Landmark(name: "Eiffel Tower", id: 1),
//            Landmark(name: "Louvre", id: 2),
//            Landmark(name: "Notre Dame", id: 3),
//            Landmark(name: "Arc de Triomphe", id: 4),
//            Landmark(name: "Palace of Versailles", id: 5)
//        ])
//    }
//}
