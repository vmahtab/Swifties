import SwiftUI
import MapKit

struct HomeView: View {
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var selected: Landmark?
    @StateObject var viewmodel = NavigationControllerViewModel()

    var body: some View {
        ZStack() {
            Group {
                Text("Hello \(User.shared.username ?? "User")")                    .font(Font.custom("Poppins", size: 26).weight(.semibold))
                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                    .offset(x: -106.50, y: -304.50)
                Text("Destinations for you")
                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                    .offset(x: -84, y: -74.50)
               
                HStack(spacing: 23) {
                    ZStack() {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 166, height: 84)
                            .background(Color(red: 1, green: 0.83, blue: 0.51))
                            .cornerRadius(10)
                            .offset(x: 0, y: 0)
                    }
                    .frame(width: 166, height: 84)
                    ZStack() {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 165, height: 84)
                            .background(Color(red: 1, green: 0.83, blue: 0.51))
                            .cornerRadius(10)
                            .offset(x: 0, y: 0)
                    }
                    .frame(width: 165, height: 84)
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .frame(width: 393, height: 86)
                .offset(x: 0, y: -159)
                Text("Go to current trip")
                    .font(Font.custom("Poppins", size: 16).weight(.medium))
                    .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                    .offset(x: -94, y: -134)
                Text("Explore nearby")
                    .font(Font.custom("Poppins", size: 16).weight(.medium))
                    .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                    .offset(x: 93.50, y: -134)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 350, height: 46)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .inset(by: 0.50)
                            .stroke(Color(red: 0.91, green: 0.91, blue: 0.91), lineWidth: 0.50)
                    )
                    .offset(x: -1.50, y: -249)
                HStack(spacing: 0) {
                    ZStack() {
                        ZStack() {
                            Ellipse()
                                .foregroundColor(.clear)
                                .frame(width: 17.98, height: 17.98)
                                .overlay(
                                    Ellipse()
                                        .stroke(Color(red: 0.67, green: 0.67, blue: 0.67), lineWidth: 0.75)
                                )
                                .offset(x: -0.39, y: -0.62)
                        }
                        .frame(width: 18.76, height: 19.22)
                    }
                    .frame(width: 24, height: 24)
                }
                .frame(width: 24, height: 24)
                .offset(x: -147.50, y: -249)
                Text("Where do you want to go?")
                    .font(Font.custom("Poppins", size: 16))
                    .foregroundColor(Color(red: 0.66, green: 0.66, blue: 0.66))
                    .offset(x: -19.50, y: -250)
            }
            SearchBarViewControllerRepresentable()
            .frame(height: 44)
        MainNavController(viewModel: viewmodel)
        }
        .frame(width: 393, height: 852)
        .background(backCol)
//                VStack {
//                    Text("Hello User")
//                        .font(.title)
//                        .padding()
//                        .foregroundColor(titleCol)
//                    
//                    Button(action: {
//                    }) {
//                        Text("Go to current trip")
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .padding()
//                            .foregroundColor(.white)
//                            .background(Color.yellow)
//                            .cornerRadius(10)
//                    }
//                    .padding(.horizontal)
//                    
//                    Button(action: {
//                    }) {
//                        Text("Explore nearby")
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .padding()
//                            .foregroundColor(.white)
//                            .background(Color.yellow)
//                            .cornerRadius(10)
//                    }
//                    
//                    .padding()
//                    Spacer()
//                    SearchBarViewControllerRepresentable()
//                        .frame(height: 44)
//                    MainNavController(viewModel: viewmodel)
//                }
//                .navigationTitle("Home")
//                .foregroundColor(titleCol)
//                .background(backCol)
        }
}


#Preview {
   HomeView()
}


//
//VStack(alignment: .leading, spacing: 10) {
//    HStack(alignment: .top, spacing: 20) {
//        Rectangle()
//            .foregroundColor(.clear)
//            .frame(width: 184, height: 184)
//            .background(
//                AsyncImage(url: URL(string: "https://via.placeholder.com/184x184"))
//            )
//            .cornerRadius(10)
//        Rectangle()
//            .foregroundColor(.clear)
//            .frame(width: 184, height: 184)
//            .background(
//                AsyncImage(url: URL(string: "https://via.placeholder.com/184x184"))
//            )
//            .cornerRadius(10)
//        Rectangle()
//            .foregroundColor(.clear)
//            .frame(width: 184, height: 184)
//            .background(
//                AsyncImage(url: URL(string: "https://via.placeholder.com/184x184"))
//            )
//            .cornerRadius(10)
//        Rectangle()
//            .foregroundColor(.clear)
//            .frame(width: 184, height: 184)
//            .background(
//                AsyncImage(url: URL(string: "https://via.placeholder.com/184x184"))
//            )
//            .cornerRadius(10)
//        Rectangle()
//            .foregroundColor(.clear)
//            .frame(width: 184, height: 184)
//            .background(
//                AsyncImage(url: URL(string: "https://via.placeholder.com/184x184"))
//            )
//            .cornerRadius(25)
//        Rectangle()
//            .foregroundColor(.clear)
//            .frame(width: 184.13, height: 184)
//            .background(
//                AsyncImage(url: URL(string: "https://via.placeholder.com/184x184"))
//            )
//            .cornerRadius(10)
//        Rectangle()
//            .foregroundColor(.clear)
//            .frame(width: 184, height: 184)
//            .background(
//                AsyncImage(url: URL(string: "https://via.placeholder.com/184x184"))
//            )
//            .cornerRadius(25)
//    }
//}
//.frame(width: 349, height: 185)
//.offset(x: -1, y: 42.50)
