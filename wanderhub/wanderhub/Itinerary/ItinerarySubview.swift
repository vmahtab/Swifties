//
//  ItinerarySubview.swift
//  wanderhub
//
//  Created by Vivianna Mahtab on 3/17/24.
//

import SwiftUI
import MapKit

struct locMarkersListRow: View {
    let marker: locMarker
    @State private var isMapping = false
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let name = marker.name, let timestamp = marker.timestamp {
                    Text(name).padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)).font(.system(size: 14))
                    Spacer()
                    Text(timestamp).padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)).font(.system(size: 14))
                }
            }
            VStack(){
                if let message = marker.message {
                    Text(message).padding(EdgeInsets(top: 8, leading: 0, bottom: 6, trailing: 0))
                }
                if let geodata = marker.geodata {
                    Text(geodata.postedFrom).padding(EdgeInsets(top: 8, leading: 0, bottom: 6, trailing: 0)).font(.system(size: 14))
                }
                if let geodata = marker.geodata {
                    Button {
                        cameraPosition = .camera(MapCamera(
                            centerCoordinate: CLLocationCoordinate2D(latitude: geodata.lat, longitude: geodata.lon), distance: 500, heading: 0, pitch:60))
                            isMapping.toggle()
                    } label: {
                        Image(systemName: "mappin.and.ellipse")
                    }
                    .navigationDestination(isPresented: $isMapping) {
                        MapView(cameraPosition: $cameraPosition, locmarker: marker)
                    }
                }
            }
            
        }
    }
}



