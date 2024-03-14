//
//  LocManager.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/13/24.
//

import Foundation
import Observation
import UIKit
import CoreLocation


final class LocDelegate: NSObject, CLLocationManagerDelegate {
    var headingStream: ((CLHeading) -> Void)?
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingStream?(newHeading)
    }
}

@MainActor
@Observable
final class LocManager {
    static let shared = LocManager()
    private let locManager = CLLocationManager()
    @ObservationIgnored let delegate = LocDelegate()
    
    private(set) var location = CLLocation()
    private(set) var isUpdating = false
    
    private var heading: CLHeading? = nil
    private let compass = ["North", "NE", "East", "SE", "South", "SW", "West", "NW", "North"]
    var compassHeading: String {
        return if let heading {
            compass[Int(round(heading.magneticHeading.truncatingRemainder(dividingBy: 360) / 45))]
        } else {
            "unknown"
        }
    }
    
    //Might be useful who knows
    var speed: String {
        switch location.speed {
        case 0.5..<5: "walking"
            case 5..<7: "running"
            case 7..<13: "cycling"
            case 13..<90: "driving"
            case 90..<139: "in train"
            case 139..<225: "flying"
            default: "resting"
        }
    }
    
    private init() {
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.delegate = delegate
    }
    
    var headings: AsyncStream<CLHeading> {
        AsyncStream(CLHeading.self) { cont in
            delegate.headingStream = {
                cont.yield($0)
            }
            cont.onTermination = { @Sendable _ in
                self.locManager.stopUpdatingHeading()
            }
            locManager.startUpdatingHeading()
        }
    }
    
    private func startUpdates() {
        if locManager.authorizationStatus == .notDetermined {
            locManager.requestWhenInUseAuthorization()
        }
        
        Task {
            do {
                for try await update in CLLocationUpdate.liveUpdates() {
                    if !isUpdating { break }
                    location = update.location ?? location
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        Task {
            for await newHeading in headings {
                if !isUpdating { break }
                heading = newHeading
            }
        }
    }
    
    func toggleUpdates() {
        isUpdating.toggle()
        if (isUpdating) {
            startUpdates()
        }
    }
    
}
