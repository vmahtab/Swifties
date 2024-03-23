import SwiftUI
import MapKit

enum Destination {
    case itinView
    case MapView
    
    var title: String {
        switch self {
        case .itinView:
            return "Itin View"
        case .MapView:
            return "Map View"
        }
    }
}

struct HomeView: View {
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var selected: Landmark?
    

    // Create navigation bar
    //let NavBar = NavigationBarViewController()
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Home View")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: ItinView(), label: {
                    Text("Go to Itinerary View")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                .padding()
                
                NavigationLink(destination: MapView(cameraPosition: $cameraPosition, landmark: selected), label: {
                    Text("Go to Map View")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                .padding()
                Spacer()
                NavigationBar()
            }
            .navigationTitle("Home")
            
        }
    }
}

