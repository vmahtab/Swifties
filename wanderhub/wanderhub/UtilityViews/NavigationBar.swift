////
////  NavigationBar.swift
////  wanderhub
////
////  Created by Alexey Kovalenko on 3/23/24.
////
//
//import SwiftUI
//import MapKit
//
//struct NavigationBar: View {
//    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
//    
//    var body: some View {
//            HStack {
//
//                Button(action: {
//                    // Action for Home button
//                }) {
//                    NavigationLink(destination: ItinView()){
//                        Image(systemName: "list.bullet")
//                            .font(.system(size: 30)) // Keep the font size the same
//                            .padding(.vertical, 10) // Adjust vertical padding
//                            .padding(.horizontal, 20) // Adjust horizontal padding
//                    }
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                }) {
//                    NavigationLink(destination: MapView(cameraPosition: $cameraPosition, landmark: nil)){
//                        Image(systemName: "safari.fill")
//                            .font(.system(size: 30)) // Keep the font size the same
//                            .padding(.vertical, 10) // Adjust vertical padding
//                            .padding(.horizontal, 20) // Adjust horizontal padding
//                    }
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    // Action for Camera button
//                }) {
//                    NavigationLink(destination: CameraView()){
//                        Image(systemName: "camera.fill")
//                            .font(.system(size: 30)) // Keep the font size the same
//                            .padding(.vertical, 10) // Adjust vertical padding
//                            .padding(.horizontal, 20) // Adjust horizontal padding
//                    }
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    // Action for Person button
//                }) {
//                    Image(systemName: "person.fill")
//                        .font(.system(size: 30)) // Keep the font size the same
//                        .padding(.vertical, 10) // Adjust vertical padding
//                        .padding(.horizontal, 20) // Adjust horizontal padding
//                }
//            }
//            .frame(height: 60) // Adjust the height of the bottom bar
//            .background(Color.gray) // Background color of the bottom bar
//            .foregroundColor(.white) // Text color of the buttons
//        }
//}
