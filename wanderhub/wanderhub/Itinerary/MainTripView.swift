//
//  MainTripView.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import SwiftUI

struct MainTripView: View {
    @ObservedObject var viewModel: NavigationControllerViewModel
    
    var body: some View {
        NavigationView{
            VStack {
                Text("What's next?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                    .foregroundColor(titleCol)
                
                // Options for starting a new trip or viewing the current itinerary
                VStack {
                    NavigationLink(destination: BookingView(viewModel: viewModel)) {
                        OptionCardView(optionTitle: "Start New Trip", iconName: "plus.circle.fill", backgroundColor: Color.blue)
                    }
                    .background(backCol)
                    NavigationLink(destination: ItineraryView(viewModel: viewModel)) {
                        OptionCardView(optionTitle: "Current Itinerary", iconName: "list.bullet", backgroundColor: Color.green)
                    }
                    .background(backCol)
                }
                .background(backCol)
                .padding()
                
                Spacer()
                ChildNavController(viewModel: viewModel)
            }
            .background(backCol)
        }
    }
}

struct OptionCardView: View {
    var optionTitle: String
    var iconName: String
    var backgroundColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .padding()
                .background(backgroundColor)
                .cornerRadius(25)
            
            Text(optionTitle)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(orangeCol)
            
            Spacer()
        }
        .padding()
        .frame(height: 80)
        .background(navBarCol)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
