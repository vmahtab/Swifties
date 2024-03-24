//
//  TripPlanning.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import SwiftUI

struct BookingView: View {
    @ObservedObject var viewModel: NavigationControllerViewModel
    @State private var destination: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack{
                Form {
                    TextField("Destination", text: $destination)
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    
                    Button("Submit Booking") {
                        let booking = TravelBooking(destination: destination, startDate: startDate, endDate: endDate)
                        submitBooking(booking: booking)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Booking Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
                .navigationBarTitle("New Booking")
                
                Spacer()
                ChildNavController(viewModel: viewModel)
            }
            .background(backCol)
        }
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




