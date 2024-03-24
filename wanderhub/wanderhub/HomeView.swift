import SwiftUI
import MapKit

struct HomeView: View {
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var selected: Landmark?
    @StateObject var viewmodel = NavigationControllerViewModel()

    var body: some View {
        NavigationView {
                VStack {
                    Text("Welcome to the Home View")
                        .font(.title)
                        .padding()
                    
                    .padding()
                    Spacer()
                    MainNavController(viewModel: viewmodel)
                }
                .navigationTitle("Home")
        }
    }
}
