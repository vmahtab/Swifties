//
//  MapView.swift
//  swiftUIChatter
//
//  Created by Alexey Kovalenko on 3/22/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: NavigationControllerViewModel
    @Binding var cameraPosition: MapCameraPosition
    @State var landmark: newLandmark?
    @State var selected: newLandmark?
    
    @ObservedObject var userItineraryStore = UserItineraryStore.shared
    
    var body: some View {
        VStack {
            Map(position: $cameraPosition, selection: $selected) {
                if let landmark {
                    Marker(landmark.landmark_name, systemImage: "figure.wave",
                           coordinate: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude))
                    .tint(.red)
                    .tag(landmark)
                } else {
                    ForEach(userItineraryStore.newLandmarks, id: \.self) { landmark in
                        Marker(landmark.landmark_name, systemImage: "figure.wave",
                               coordinate: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude))
                        .tint(.mint)
                    }
                }
                if let landmark = selected {
                    Annotation(landmark.landmark_name, coordinate: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude), anchor: .topLeading
                    ) {
                        InfoView(landmark: landmark)
                    }
                    .annotationTitles(.hidden)
                }
                ForEach(LandmarkStore.shared.nearest, id: \.self) { landmark in
                        Marker(landmark.landmark, systemImage: "questionmark.circle.fill",
                               coordinate: CLLocationCoordinate2D(latitude: landmark.latitude, longitude: landmark.longitude))
                            .tint(.mint)
                }
                
                UserAnnotation() // shows user location
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
        }
        .onAppear {
            Task {
                await LandmarkStore.shared.getNearest()
            }
        }
        Spacer()
        ChildNavController(viewModel: viewModel)
    }
}

struct InfoView: View {
    let landmark: newLandmark
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(landmark.landmark_name).padding(EdgeInsets(top: 4, leading: 8, bottom: 0, trailing: 0)).font(.system(size: 16))
            }
//            if let message = landmark.message {
//                Text(message).padding(EdgeInsets(top: 1, leading: 8, bottom: 0, trailing: 4)).font(.system(size: 14)).lineLimit(2, reservesSpace: true)
//            }
            Text("latitude: \(landmark.latitude) longitude: \(landmark.longitude)").padding(EdgeInsets(top: 0, leading: 8, bottom: 10, trailing: 4)).font(.system(size: 12)).lineLimit(2, reservesSpace: true)
        }
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .cornerRadius(4.0)
        }
        .frame(width: 300)
    }
}
