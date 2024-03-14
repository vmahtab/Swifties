//
//  PostView.swift
//  swiftUIChatter
//
//  Created by Alexey Kovalenko on 1/22/24.
//

import SwiftUI

struct MarkerView: View {
    @Binding var isPresented: Bool

    private let username = "alexeyk"
    @State private var message = "Some short sample text."
    
    var body: some View {
        VStack {
            Text(username)
                .padding(.top, 30.0)
            TextEditor(text: $message)
                .padding(EdgeInsets(top: 10, leading: 18, bottom: 0, trailing: 4))
        }
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.navigationBarTrailing) {
                SubmitButton()
            }
        }
        .onAppear { LocManager.shared.toggleUpdates() }
        .onDisappear { LocManager.shared.toggleUpdates() }
        //Text("\(LocManager.shared.location.coordinate.latitude), \(LocManager.shared.location.coordinate.latitude), \(LocManager.shared.speed), \(LocManager.shared.compassHeading)")
    }
    
    @MainActor
    @ViewBuilder
    func SubmitButton() -> some View {
        Button {
            var geodata = GeoData(lat: LocManager.shared.location.coordinate.latitude, lon: LocManager.shared.location.coordinate.longitude, facing: LocManager.shared.compassHeading, speed: LocManager.shared.speed)
                Task {
                    await geodata.setPlace()
                    locMarkers.shared.postLocMarkers(locMarker(name: username, message: message, geodata: geodata)) {
                        locMarkers.shared.getLocMarkers()
                    }
                    isPresented.toggle()
                }
            isPresented.toggle()
        } label: {
            Image(systemName: "paperplane")
        }
    }
}
