//
//  ContentView.swift
//  wanderhub
//
//  Created by Hasan Zengin on 3/12/24.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    @State private var mapPresenting = false
    @State var cameraPosition = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
    
    var body: some View {
        VStack {
            Button(action: {
                mapPresenting.toggle()
                LocManager.shared.toggleUpdates()
            }) {
                Image(systemName: "map")
            }
            .sheet(isPresented: $mapPresenting) {
                MapView(mapPresenting: self.$mapPresenting)
            }
        }
    }
}





#Preview {
    ContentView()
}
