import SwiftUI
import MapKit

struct HomeView: View {
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var selected: Landmark?
    @StateObject var viewmodel = NavigationControllerViewModel()
    
    var body: some View {
        
        VStack() {
            Spacer().frame(height: 75)
            HStack(){
                Spacer().frame(width: 5)
                Text("Hello \(User.shared.username ?? "User")")                    .font(Font.custom("Poppins", size: 26).weight(.bold))
                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                    .offset(x: 10, y: 30)
                    .frame(alignment: .leading)
                Spacer()
                
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
      
           //no search needed here
//            SearchBarViewControllerRepresentable()
//                .frame(height: 44)
//                .offset(x: 0, y: 30)
//            
            HStack(spacing: 23) {
                ZStack() {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 166, height: 84)
                        .background(Color(red: 1, green: 0.83, blue: 0.51))
                        .cornerRadius(10)
                        .offset(x: 0, y: 0)
                    
                    Button(action: {
                        viewmodel.viewState = ViewState.itinerary
                        viewmodel.isPresented = true
                        viewmodel.NavigatingToCurrentTrip = true
                    }) {
                        Text("Go to current trip")
                            .font(Font.custom("Poppins", size: 16).weight(.medium))
                            .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                        
                    }
                }
                
                ZStack() {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 165, height: 84)
                        .background(Color(red: 1, green: 0.83, blue: 0.51))
                        .cornerRadius(10)
                        .offset(x: 0, y: 0)
                    Button(action: {
                        viewmodel.viewState = ViewState.map(nil)
                        viewmodel.isPresented = true
                    }) {
                        Text("Explore Nearby")
                            .font(Font.custom("Poppins", size: 16).weight(.medium))
                            .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                        
                    }
                    
                    
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .frame(width: 393, height: 86)
            .offset(x: 0, y: 50)
            VStack(){
                Text("Destinations for you")
                           .font(Font.custom("Poppins", size: 18).weight(.semibold))
                           .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                           .offset(x: 10, y: 75)
                           .frame(maxWidth: .infinity, alignment: .leading)
                           .padding()
              
                HStack(spacing: 24) {
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 80, height: 79.94)
                            .background(
                                Image("Mountains")
                                        .resizable()
                                        .scaledToFit()                            )
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.06, trailing: 0))
                    .frame(width: 80, height: 80)
                    .background(Color(red: 1, green: 1, blue: 1))
                    .cornerRadius(8)
                    .shadow(
                        color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                    )
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 0) {
                            HStack(alignment: .top, spacing: 38) {
                                Text("Huron-Manistee National Forest")
                                    .font(Font.custom("Cabin", size: 14).weight(.semibold))
                                    .lineSpacing(22.40)
                                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(width: 234)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .frame(width: 370, height: 96)
                .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                .cornerRadius(8)
                .shadow(
                    color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                )
                .offset(x:0, y:80)
// destination 2
                HStack(spacing: 24) {
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 80, height: 79.94)
                            .background(
                                Image("Forest")
                                        .resizable()
                                        .scaledToFit()
                            )
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.06, trailing: 0))
                    .frame(width: 80, height: 80)
                    .background(Color(red: 1, green: 1, blue: 1))
                    .cornerRadius(8)
                    .shadow(
                        color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                    )
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 0) {
                            HStack(alignment: .top, spacing: 38) {
                                Text("Bell Tower")
                                    .font(Font.custom("Cabin", size: 14).weight(.semibold))
                                    .lineSpacing(22.40)
                                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(width: 234)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .frame(width: 370, height: 96)
                .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                .cornerRadius(8)
                .shadow(
                    color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                )
                .offset(x:0, y:80)
//destination 3
                HStack(spacing: 24) {
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 80, height: 79.94)
                            .background(
                                Image("Shore")
                                    .resizable()
                                    .scaledToFit()
                            )
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.06, trailing: 0))
                    .frame(width: 80, height: 80)
                    .background(Color(red: 1, green: 1, blue: 1))
                    .cornerRadius(8)
                    .shadow(
                        color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                    )
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 0) {
                            HStack(alignment: .top, spacing: 38) {
                                Text("White Shore Lake")
                                    .font(Font.custom("Cabin", size: 14).weight(.semibold))
                                    .lineSpacing(22.40)
                                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(width: 234)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .frame(width: 370, height: 96)
                .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                .cornerRadius(8)
                .shadow(
                    color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                )
                .offset(x:0, y:80)
//destination 4
                HStack(spacing: 24) {
                    HStack(spacing: 0) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 80, height: 79.94)
                            .background(
                                Image("Greenland")
                                        .resizable()
                                        .scaledToFit()                            )
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0.06, trailing: 0))
                    .frame(width: 80, height: 80)
                    .background(Color(red: 1, green: 1, blue: 1))
                    .cornerRadius(8)
                    .shadow(
                        color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                    )
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 0) {
                            HStack(alignment: .top, spacing: 38) {
                                Text("Nichols Arboretum")
                                    .font(Font.custom("Cabin", size: 14).weight(.semibold))
                                    .lineSpacing(22.40)
                                    .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(width: 234)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .frame(width: 370, height: 96)
                .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                .cornerRadius(8)
                .shadow(
                    color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                )
                .offset(x:0, y:80)

            }
            Spacer()
            
            MainNavController(viewModel: viewmodel)
            Spacer()
                .frame(height:15)
            
        }
        .background(backCol)
        //
        
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
