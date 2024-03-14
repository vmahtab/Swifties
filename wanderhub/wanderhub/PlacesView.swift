//
//  ContentView.swift
//  wanderhub
//
//  Created by Hasan Zengin on 3/12/24.
//

import SwiftUI
import MapKit

struct PlacesView: View {
    @State private var isMapping = false
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    private let store = locMarkers.shared
    
    @State private var isPresenting = false

    var body: some View {
        List(store.markers.indices, id: \.self) {
            locMarkersListRow(marker: store.markers[$0])
                .listRowSeparator(.hidden)
                .listRowBackground(Color(($0 % 2 == 0) ? .systemGray5 : .systemGray6))
        }
        // added this update to initialize the camera in case we swipe
        .onAppear {
            LocManager.shared.toggleUpdates()
        }
        .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                if case (...0, -100...100) = (value.translation.width, value.translation.height) {
                    cameraPosition = .camera(MapCamera(
                       centerCoordinate: CLLocationCoordinate2D(latitude: LocManager.shared.location.coordinate.latitude, longitude: LocManager.shared.location.coordinate.longitude), distance: 500, heading: 0, pitch: 60))
                    isMapping.toggle()
                }
            }
        )
       .navigationDestination(isPresented: $isMapping) {
            MapView(cameraPosition: $cameraPosition, locmarker: nil)
        }
        .listStyle(.plain)
        .refreshable{
            store.getLocMarkers()
        }
        .navigationTitle("Chatter")
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement:.navigationBarTrailing) {
//                Button {
//                    isPresenting.toggle()
//                } label: {
//                    Image(systemName: "square.and.pencil")
//                }
//            }
//        }
//        .navigationDestination(isPresented: $isPresenting) {
//            MarkerView(isPresented: $isPresenting)
//        }
        
    }
}


