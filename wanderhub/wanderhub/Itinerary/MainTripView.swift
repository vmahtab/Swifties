//
//  MainTripView.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import SwiftUI


struct Itinerary: Decodable {
    var id: Int
    var city_name: String
    var it_name: String
    var start_date: String
    var end_date: String
    
}

struct MainTripView: View {
    @ObservedObject var viewModel: NavigationControllerViewModel
    @ObservedObject var userItineraryStore = UserItineraryStore.shared // Observe the UserItineraryStore
    
    @State var current_it_name: String?
    @State var is_itin_active = false
    
    
    var body: some View {
        NavigationStack{
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
//                    NavigationLink(destination: ItineraryView(viewModel: viewModel, itineraryID: userItineraryStore.currentTripID ?? 0, it_name: <#T##Binding<String>#>)) {
//                        OptionCardView(optionTitle: "Current Itinerary", iconName: "list.bullet", backgroundColor: Color.green)
//                    }
//                    .background(backCol)
                    HStack {
                        Text("Upcoming Trips:")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(titleCol)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        
                        Button(action: {
                            Task {
                                await userItineraryStore.getUpcomingTrips()
                            }
                        }) {
                            Text("Refresh")
                                .foregroundColor(.blue)
                                .padding(.trailing)
                        }
                    }
                    
                    ScrollView(showsIndicators: false) {
                        ForEach(userItineraryStore.itineraries, id: \.id) { itinerary in
                            NavigationLink(destination: ItineraryView(viewModel: viewModel, itineraryID: itinerary.id, it_name: itinerary.it_name, date: itinerary.start_date),
                                label: {
                                    HStack{
                                        VStack(alignment: .leading) {
                                            Text(itinerary.it_name)
                                                .font(.headline)
                                            Text("\(itinerary.city_name), \(itinerary.start_date)")
                                                .font(.subheadline)
                                        }
                                        
                                    }
                                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                    .frame(width: 370, height: 96)
                                    .background(Color(red: 0.94, green: 0.92, blue: 0.87))
                                    .cornerRadius(8)
                                    .shadow(
                                        color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6
                                    )
                            })
//                            .onAppear {
//                                Task {
//                                    await userItineraryStore.getTripDetails(itineraryID: itinerary.id)
//                                }
//                            }
                        }
                    }
                    .onAppear {
                        Task {
                            await userItineraryStore.getUpcomingTrips()
                        }
                    }
                    .refreshable {
                        Task {
                            await userItineraryStore.getUpcomingTrips()
                        }
                    }
                }
            }
            .background(backCol)
            //.padding()
            
            Spacer()
            ChildNavController(viewModel: viewModel)
        }
        .background(backCol)
//        .navigationDestination(isPresented: $viewModel.NavigatingToCurrentTrip) {
//            ItineraryView(viewModel: viewModel, itineraryID: userItineraryStore.currentTripID ?? 0)
//        }
        
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

struct newLandmark: Identifiable, Hashable, Decodable {
    var item_id: Int
    var landmark_name: String
    var latitude: Double
    var longitude: Double
    var trip_day: Int
        
    var id: String { landmark_name }
    
    //var favorite: Bool = false
}

struct newLandmarkResponse: Decodable {
    var newLandmarks: [newLandmark]
}

class UserItineraryStore :ObservableObject {
    
    static let shared = UserItineraryStore()
    private init() {}
    @Published var itineraries: [Itinerary] = [] // Use @Published here instead of @ObservedObject
    @Published var currentTripID: Int? // Variable to hold the current trip's ID
    @Published var currentTripName: String? // Variable to hold the current trip's ID
    @Published var currentTripStartDate: String? // Variable to hold the current trip's ID

    @Published var days: Int?
    @State private var itineraryID: Int? = nil
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    
    @Published var newLandmarks = [newLandmark]()
    
    func getUpcomingTrips() async {
        
        guard let apiUrl = URL(string: "\(serverUrl)get-user-itineraries/") else { // TODO REPLACE URL
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
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("get upcoming trips: HTTP STATUS: \(httpStatus.statusCode)")
                print("Response:")
                print(response)
                return
            }
            
            print("get nearby  trips::")
            //            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
            //                print("addUser: failed JSON deserialization")
            //                return
            //            }
            let decoder = JSONDecoder()
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let landmarksArray = jsonObject["itineraries"] as? [[String: Any]] else {
                    print("Failed to parse JSON data")
                    return
                }
                //print(landmarksArray)
                
                let decodedLandmarks = try landmarksArray.map { landmarkDict in
                    return try JSONDecoder().decode(Itinerary.self, from: JSONSerialization.data(withJSONObject: landmarkDict))
                }
                
                DispatchQueue.main.async {
                    self.itineraries = decodedLandmarks
                }
                // Set the current trip ID to the ID of the first itinerary, if available
                if let firstItineraryID = decodedLandmarks.first {
                    self.currentTripID = firstItineraryID.id
                    self.currentTripName = firstItineraryID.city_name
                    self.currentTripStartDate = firstItineraryID.start_date
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
            
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        
        return
        
    }
    
    
    func addLandmarktoItinerary(itineraryID: Int, day: String) async {
        
        let jsonObj = ["itinerary_id": itineraryID,
                       "day": day] as [String : Any]
        print(jsonObj)
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("addUser: jsonData serialization error")
            return
        }
        
        guard let apiUrl = URL(string: "\(serverUrl)add-to-itinerary/") else { // TODO REPLACE URL
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
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("get upcoming trips: HTTP STATUS: \(httpStatus.statusCode)")
                print("Response:")
                print(response)
                return
            }
            print("Response:")
            print(response)
            print("add destination: ")
          
            Task {
                await getTripDetails(itineraryID: itineraryID)
            }
            
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        
        return
        
    }
    
//    func removeLandmark(id: Int) async {
//        await MainActor.run {
//            newLandmarks.removeAll { $0.id == id }
//            
//            // need to implement delete request for the itinerary
//        }
//    }
    
    func getTripDetails(itineraryID: Int) async {
        
        let jsonObj = ["itinerary_id": itineraryID]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("postChatt: jsonData serialization error")
            return
        }
        
        guard let apiUrl = URL(string: "\(serverUrl)get-itinerary-details/") else { // TODO REPLACE URL
            print("addUser: Bad URL")
            return
        }
        guard let token = UserDefaults.standard.string(forKey: "usertoken") else {
            return
        }
        print(jsonObj)
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept") // expect response in JSON
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            
        
            
            let decoder = JSONDecoder()
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Failed to parse JSON data")
                    return
                }
                print(jsonObject)
                guard let landmarksArray = jsonObject["itinerary"] as? [String: Any] else {
                       print("Failed to parse landmarks array from JSON data")
                       return
                   }
                
                print(landmarksArray)
                guard let landmarksArray = landmarksArray["items"] as? [[String: Any]] else {
                       print("Failed to parse landmarks array from JSON data")
                       return
                   }
                print("final     ", landmarksArray)

                
                let decodedLandmarks = try landmarksArray.map { landmarkDict -> newLandmark in
                        let landmarkData = try JSONSerialization.data(withJSONObject: landmarkDict)
                        return try JSONDecoder().decode(newLandmark.self, from: landmarkData)
                    }
                
                print("Decoded landmarks: ", decodedLandmarks)
                self.newLandmarks = decodedLandmarks
                
                DispatchQueue.main.async {
                    self.newLandmarks = decodedLandmarks 
                    print("self.newlandmarks is ",self.newLandmarks)

                }
                print("self.newlandmarks is ",self.newLandmarks)
                // Set the current trip ID to the ID of the first itinerary, if available
                if let firstItineraryID = decodedLandmarks.first?.id {
                    self.currentTripID = Int(firstItineraryID)
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
//            if let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//               let landmarksArray = jsonObject["items"] as? [[String: Any]] { // Use the key that actually contains your landmarks data
//                
//                }
//              //  let landmarksArray = jsonObject["i"] as? [[String: Any]]  // Use the key that actually contains your landmarks data
//              //  let landmarksArray = jsonObject["items"] as? [[String: Any]] // Use the key that actually contains your landmarks data
//                let landmarksArray = jsonObject["items"] as? [[String: Any]]  // Use the key that actually contains your landmarks data
//            let decodedLandmarks = try landmarksArray.map { landmarkDict -> newLandmark in
//                let landmarkData = try JSONSerialization.data(withJSONObject: landmarkDict)
//                return try decoder.decode(newLandmark.self, from: landmarkData)
//                DispatchQueue.main.async {
//                    self.newLandmarks = decodedLandmarks
//                    
//                    //Print the new landmarks array if needed
//                    //print(self.newLandmarks)
//                }
//            } else {
//                print("Failed to parse JSON data")
//            }
            
        } catch {
            print("Request failed with error: \(error)")
        }
        
        
        return
        
    }
    
    
    
}



