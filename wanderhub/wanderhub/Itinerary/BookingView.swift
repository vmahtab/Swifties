//
//  TripPlanning.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import SwiftUI
import Foundation

struct BookingView: View {
    @ObservedObject var viewModel: NavigationControllerViewModel
    @State private var destination: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
                VStack {
                    Spacer()
                        .frame(height: 50)
                    TextField("Destination", text: $destination)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 1)
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 1)
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 1)
                    
                    
                    Button("Submit Booking") {
                        let booking = TravelBooking(destination: destination, startDate: startDate, endDate: endDate)
                        submitBooking(booking: booking)
                    }
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(5)
                    .shadow(radius: 1)
                    
                    Spacer()
                    ChildNavController(viewModel: viewModel)
                }
                .background(backCol)
                .padding(.horizontal)
                // ChildNavController or any other views you want to display
    }

    private func submitBooking(booking: TravelBooking) {
        let service = TravelBookingService()
        service.submitBooking(booking: booking) { success, error in
            if let error = error {
                // Handle the error scenario
                alertMessage = "Error: \(error.localizedDescription)"
                showingAlert = true
            } else if success {
                // Handle the success scenario
                alertMessage = "Booking successfully submitted."
                showingAlert = true
            } else {
                // Handle the failure scenario
                alertMessage = "Failed to submit the booking."
                showingAlert = true
            }
        }
    }
}




