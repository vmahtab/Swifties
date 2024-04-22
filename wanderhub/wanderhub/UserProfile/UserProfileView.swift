//
//  UserProfileView.swift
//  wanderhub
//
//  Created by Neha Tiwari on 3/24/24.
//

import SwiftUI
import Foundation
import SwiftUI

struct UserProfileView: View {
    @ObservedObject var viewModel: NavigationControllerViewModel
    @ObservedObject var userHistorystore = UserHistoryStore.shared
    @State private var isDataLoaded = false
    
    @State private var refreshID = UUID()
    @State var identified: [LandmarkVisit]
    
    
    var body: some View {
        NavigationStack{
            VStack{
                GreetUser()
                ProfileOptions()
                HStack{
                    Text("Past Landmarks:")
                        .font(Font.custom("Poppins", size: 16).weight(.semibold))
                        .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(width: 352, height: 39)
                VStack {
                    List(identified.indices, id: \.self) { index in
                        LandmarkListRow(visit: $identified[index], tempRating: $identified[index].rating)
                            .listRowSeparator(.hidden)
                            .listRowBackground(backCol)
                            .id(refreshID)
                    }
                    .listStyle(.plain)
                    .refreshable {
                        printLandmarkVisits()
                        refreshID = UUID()
                        Task {
                            await userHistorystore.getHistory()
                            identified = UserHistoryStore.shared.visitedPlaces()
                        }
                    }
                    .frame(maxHeight: .infinity)
                }
                .onAppear {
                    Task {
                        await userHistorystore.getHistory()
                        identified = UserHistoryStore.shared.visitedPlaces()
                    }
                    
                    
                }
                .onChange(of: userHistorystore.landmarkVisits) {  oldValue, newValue in
                    refreshID = UUID() // Update UUID to force redraw
                }
                
                Spacer()
                ChildNavController(viewModel: viewModel)
            }
            .background(backCol)
            
        }
    }
    
    @ViewBuilder
    private func GreetUser()-> some View {
        HStack(spacing: 161) {
            Text("Hello \(User.shared.username ?? "User")")
                .font(Font.custom("Poppins", size: 26).weight(.semibold))
                .foregroundColor(Color(red: 0, green: 0.15, blue: 0.71))
                .frame(maxWidth: .infinity, alignment: .leading) //
        }
        .frame(width: 352, height: 39)
    }
    
    @ViewBuilder
    private func ProfileOptions()-> some View {
            VStack(alignment: .trailing, spacing: 0) {
//                HStack(spacing: 12) {
//                    Text("Settings")
//                        .font(Font.custom("Poppins", size: 16).weight(.medium))
//                        .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 16))
//                .frame(width: 343)
//                .background(Color(red: 0.94, green: 0.92, blue: 0.87))
//                .cornerRadius(10)
                
                @State var mock_sign: Bool = true
                @State var mock_dismiss: Bool = true
                NavigationLink(destination: Onboard(signinProcess: $mock_sign, showDismiss: $mock_dismiss)){
                    HStack(spacing: 12) {
                        Text("Preferences")
                            .font(Font.custom("Poppins", size: 16).weight(.medium))
                            .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 16))
                    .frame(width: 343)
                    .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                }
                NavigationLink(destination: FAQsView()){
                    HStack(spacing: 12) {
                        Text("FAQs")
                            .font(Font.custom("Poppins", size: 16).weight(.medium))
                            .foregroundColor(Color(red: 0.96, green: 0.40, blue: 0.33))
                            .frame(maxWidth: .infinity, alignment: .leading) //
                    }
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 16))
                    .frame(width: 343)
                    .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                    .cornerRadius(10)
                }
            }
            .frame(width: 356)
            .background(Color(red: 0.94, green: 0.92, blue: 0.87))
            .cornerRadius(10)
        }
    

    
    private func printLandmarkVisits() {
        print("tetsign from profile view",userHistorystore.landmarkVisits)
    }
    
   
}


struct StarRatingView: View {
    @Binding var rating: Int

    var body: some View {
        HStack {
            Text("Rate me ")
                .foregroundColor(.blue)
                .padding(.top, 4)
            
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .foregroundColor(star <= rating ? .yellow : .gray)
                    .onTapGesture {
                        rating = star
                    }
            }
        }
    }
}

struct LandmarkListRow: View {
    @Binding var visit: LandmarkVisit
    @Binding var tempRating: Int



    var body: some View {
        HStack {
            if let urlString = visit.image_url, let imageUrl = URL(string: urlString) {
                AsyncImage(url: imageUrl) {
                    $0.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                } placeholder: {
                    Image(systemName: "airplane.departure")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                }
                .scaledToFit()
                .frame(height: 181)
            } else {
                Image(systemName: "airplane.departure")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
            }

            VStack(alignment: .leading) {
                Text(visit.landmark_name).font(.headline)
                Text("\(visit.city_name), \(visit.country_name)").font(.subheadline)
                if visit.description != "Unknown" {
                    Text("\(visit.description), \(visit.tags.joined(separator: ", "))")
                }
                Text("Rated: \(visit.rating)/5, \(visit.visit_time)")
                
                StarRatingView(rating: $tempRating)
                    .frame(width: 100, height: 20)
                
//                Button(action: {
//                    print("Rating submitted: \(tempRating)")
//                    Task {
//                        await submitRating(id: visit.landmark_name, newRating: tempRating)
//                    }
//                }) {
//                    Text("Submit Rating")
//                        .foregroundColor(.blue)
//                        .padding(.top, 4)
//                }
            }
            Spacer()
        }
       // .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .frame(width: 370, height: 150) // Adjusted for additional content
        .background(Color(red: 0.94, green: 0.92, blue: 0.87))
        .cornerRadius(8)
        .shadow(
            color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
        )
    }
    
    func submitRating(id: String, newRating: Int) async {
        //var landmark2Rate = landmarks.first { $0.id == id }
        //landmark2Rate?.rating = rating
        //make a post request to rate the landmark
        
        let jsonObj = ["landmark_name": id,
                       "new_rating": String(newRating)]
        print(jsonObj)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("addUser: jsonData serialization error")
            return
        }
        
        guard let apiUrl = URL(string: "\(serverUrl)testing_update_landmark_rating/") else { // TODO REPLACE URL
            print("addUser: Bad URL")
            return
        }
        
        guard let token = UserDefaults.standard.string(forKey: "usertoken") else {
            return
        }
       
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = jsonData

        
        do {

            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("submit rating: HTTP STATUS: \(httpResponse.statusCode)")
                print("Response:")
                print(response)
                return
            }

            print("Response:")
            print(response)
    
            
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
       // reloadID = UUID()

        
        
    }
//
//    func formatDate(_ String: Date) -> String {
//        let components = dateTimeString.components(separatedBy: " ")
//
//        // Extract date and time components
//        let dateString = components[0] // "2024-04-22"
//        let timeString = components[1] // "01:25:30"
//
//        print("Date: \(dateString)")
//        print("Time: \(timeString)")
//        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM d, yyyy h:mm a"
//        return formatter.string(from: date)
//    }
    
    
    
}
