//
//  MapView.swift
//  swiftUIChatter
//
//  Created by Alexey Kovalenko on 3/13/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var cameraPosition: MapCameraPosition
    let locmarker: locMarker?
    @State var selected: locMarker?
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selected) {
            if let locmarker {
                if let geodata = locmarker.geodata {
                    Marker(locmarker.name!, systemImage: "figure.wave",
                           coordinate: CLLocationCoordinate2D(latitude: geodata.lat, longitude: geodata.lon))
                    .tint(.red)
                    .tag(locmarker)
                }
            } else {
                ForEach(locMarkers.shared.markers, id: \.self) { markEntry in
                    if let geodata = markEntry.geodata {
                        Marker(markEntry.name!, systemImage: "figure.wave",
                               coordinate: CLLocationCoordinate2D(latitude: geodata.lat, longitude: geodata.lon))
                        .tint(.mint)
                    }
                }
            }
            if let selMark = selected, let geodata = selMark.geodata {
                Annotation(selMark.name!, coordinate: CLLocationCoordinate2D(latitude: geodata.lat, longitude: geodata.lon), anchor: .topLeading
                ) {
                    InfoView(locmarker: selMark)
                }
                .annotationTitles(.hidden)
            }
            
            UserAnnotation() // shows user location
        }
        .mapStyle(.hybrid(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
    }
}

struct InfoView: View {
    let locmarker: locMarker
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let name = locmarker.name, let timestamp = locmarker.timestamp {
                    Text(name).padding(EdgeInsets(top: 4, leading: 8, bottom: 0, trailing: 0)).font(.system(size: 16))
                    Spacer()
                    Text(timestamp).padding(EdgeInsets(top: 4, leading: 8, bottom: 0, trailing: 4)).font(.system(size: 12))
                }
            }
            if let message = locmarker.message {
                Text(message).padding(EdgeInsets(top: 1, leading: 8, bottom: 0, trailing: 4)).font(.system(size: 14)).lineLimit(2, reservesSpace: true)
            }
            if let geodata = locmarker.geodata {
                Text("\(geodata.postedFrom)").padding(EdgeInsets(top: 0, leading: 8, bottom: 10, trailing: 4)).font(.system(size: 12)).lineLimit(2, reservesSpace: true)
            }
        }
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .cornerRadius(4.0)
        }
        .frame(width: 300)
    }
}
