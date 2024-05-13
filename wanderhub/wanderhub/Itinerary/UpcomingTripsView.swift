//
//  UpcomingTripsView.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 4/13/24.
//

import Foundation
import SwiftUI

class UpcomingTrips: ObservableObject {
    @Published var destinations: [Destination]
    init() {
        do{
            self.destinations = []
            get_destinations()
        }
    }
    
    //FIXME: Implement Upcoming trips
    func get_destinations() {
    //    self.destinations = [destination1, destination2, destination3, destination4]
        return
    }
    
}

struct UpcomingTripsView: View {
    
    var body: some View {
        GreetUser()
            .padding(.bottom, 40)
            .padding(.leading, -10)
        SearchBarViewControllerRepresentable()
        Spacer()
        
    }
    
    
    @ViewBuilder
    private func GreetUser() -> some View {
        Spacer().frame(height: 75)
        HStack(){
            Spacer().frame(width: 5)
            Text("Hello \(User.shared.username ?? "User")")
                .font(Font.custom("Poppins", size: 26).weight(.bold))
                .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                .offset(x: 10, y: 30)
                .frame(alignment: .leading)
            Spacer()
            
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
    
//    @ViewBuilder
//    private func DisplayDestinations()-> some View {
//            ScrollView(showsIndicators: false) {
//                ForEach(destinations.destinations, id: \.destination){ destination in
//                    NavigationLink(destination: BookingView(viewModel: viewmodel,
//                                                            destination: destination.destination,
//                                                            city: destination.city,
//                                                            country: destination.country,
//                                                            interests: destination.interests) ) {
//                        DisplayDestination(destination: destination)
//                    }
//                }
//            }
//            .refreshable {
//                destinations.get_destinations()
//            }
//            .offset(x: 0, y: 40)
//    }
//    
    @ViewBuilder
    private func DisplayDestination(destination: Destination)-> some View {
        HStack() {
            Image(systemName: "airplane.departure")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading){
                Text(destination.landmark_name).font(.headline)
                Text("\(destination.city_name), \(destination.country_name)").font(.subheadline)
                Text(destination.tags.joined(separator: ", "))
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .frame(width: 370, height: 96)
        .background(Color(red: 0.94, green: 0.92, blue: 0.87))
        .cornerRadius(8)
        .shadow(
            color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
        )
    }
    
    
    
}
