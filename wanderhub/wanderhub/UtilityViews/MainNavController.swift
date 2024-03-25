//
//  NavigationController.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import Foundation
import SwiftUI
import MapKit

class NavigationControllerViewModel: ObservableObject {
    @Published var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var viewState: ViewState = .home
    @Published var isPresented: Bool = false
    
    @Published var NavigatingToCurrentTrip = false
    
    func itineraryDirectNavigation(landmark: Landmark) {
        viewState = .map(landmark)
    }
    
}

struct MainNavController: View {
    @ObservedObject var viewModel: NavigationControllerViewModel
    
    var body: some View {
        HStack {
            Button {
                viewModel.viewState = .home
                viewModel.isPresented = false
            } label: {
                Image(systemName: "house")
                    .font(.system(size: 30))
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
            }
            Button {
                viewModel.viewState = .itinerary
                viewModel.isPresented = true
            } label: {
                Image(systemName: "list.bullet")
                    .font(.system(size: 30))
                    .padding(.vertical, 15)
                    .padding(.horizontal, 20)
            }
            Button {
                viewModel.viewState = .map(nil)
                viewModel.isPresented = true
            } label: {
                Image(systemName: "safari")
                    .font(.system(size: 30)) // Keep the font size the same
                    .padding(.vertical, 10) // Adjust vertical padding
                    .padding(.horizontal, 20) // Adjust horizontal padding
            }
            Button {
                viewModel.viewState = .landmark
                viewModel.isPresented = true
            } label: {
                Image(systemName: "camera")
                    .font(.system(size: 30)) // Keep the font size the same
                    .padding(.vertical, 10) // Adjust vertical padding
                    .padding(.horizontal, 20) // Adjust horizontal padding
            }
            Button {
                viewModel.viewState = .profile
                viewModel.isPresented = true
            } label: {
                Image(systemName: "person")
                    .font(.system(size: 30))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
            }
            
            .fullScreenCover(isPresented: $viewModel.isPresented) {
                switch viewModel.viewState {
                case .map(let selectedLandmark):
                    MapView(viewModel: viewModel, cameraPosition: $viewModel.cameraPosition, landmark: selectedLandmark)
                case .home:
                    HomeView()
                case .itinerary:
                    //ItinView(viewModel: viewModel)
                    MainTripView(viewModel: viewModel)
                case .landmark:
                    CameraView(viewModel: viewModel)
                case .profile:
                    UserProfileView(viewModel: viewModel)
                default:
                    Text("Other view")
                    ChildNavController(viewModel: viewModel)
                }
            }
        }
        .frame(height: 50)
        .background(navBarCol)
        .foregroundColor(.black)
    }
}
