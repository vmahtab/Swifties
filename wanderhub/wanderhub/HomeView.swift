import SwiftUI
import MapKit

struct HomeView: View {
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var selected: Landmark?
    @StateObject var viewmodel = NavigationControllerViewModel()

    var body: some View {
        NavigationView {
                VStack {
                    Text("Hello User")
                        .font(.title)
                        .padding()
                        .foregroundColor(titleCol)
                    
                    Button(action: {
                    }) {
                        Text("Go to current trip")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.yellow)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                    }) {
                        Text("Explore nearby")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.yellow)
                            .cornerRadius(10)
                    }
                    
                    .padding()
                    Spacer()
                    SearchBarViewControllerRepresentable()
                        .frame(height: 44)
                    MainNavController(viewModel: viewmodel)
                }
                .navigationTitle("Home")
                .foregroundColor(titleCol)
                .background(backCol)
        }
    }
}
