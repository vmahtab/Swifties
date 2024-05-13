//
//  ItineraryView.swift
//  wanderhub
//
//  Created by Vivianna Mahtab on 3/17/24.
//

import Foundation
import SwiftUI
import _MapKit_SwiftUI


// TODO: get a date object dynamically from backend
// takes in format ""DD/MM/YYYY", "hh:mm"
func getDateObject(_ date: String, _ time: String) -> Date {
    
    var components = DateComponents()
    
    let date_arr = date.split(separator: "/")
    let time_arr = time.split(separator: ":")
    
    components.month = Int(date_arr[0]) ?? 0
    components.day   = Int(date_arr[1]) ?? 0
    components.year  = Int(date_arr[2]) ?? 0
    
    components.hour   = Int(time_arr[0]) ?? 0
    components.minute = Int(time_arr[1]) ?? 0
    
    let calendar = Calendar.current
    return calendar.date(from: components)!
}



struct ItineraryDropViewDelegate: DropDelegate {
    
    let destinationLandmark: newLandmark
    @Binding var landmarks: [newLandmark]
    @Binding var draggedLandmark: newLandmark?
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    func performDrop(info: DropInfo) -> Bool {
        draggedLandmark = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        if let draggedLandmark {
            let fromIndex = landmarks.firstIndex(of: draggedLandmark)
            
            if let fromIndex {
                let toIndex = landmarks.firstIndex(of: destinationLandmark)
                
                if let toIndex, fromIndex != toIndex {
                    withAnimation {
                        self.landmarks.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex))
                    }
                }
            }
        }
    }
}

struct ItineraryHeaderView: View {
    
    // TODO: get this data from backend
    @Binding var tripName: String?
    
    @Binding var tripStartDate: String?//Date = getDateObject("11/11/2023", "00:00")
    @State var tripEndDate:   Date = getDateObject("11/15/2023", "00:00")
    
    // surprisingly complex, not inlining in View
//    func getTripDateRange() -> String {
//
//        let dateFormatter = DateFormatter()
//
//        // get months
//        dateFormatter.dateFormat = "LLLL"
//        let startMonthString = dateFormatter.string(from: tripStartDate)
//        let endMonthString   = dateFormatter.string(from: tripEndDate)
//
//        dateFormatter.dateFormat = "dd"
//        let startDayString = dateFormatter.string(from: tripStartDate)
//        let endDayString = dateFormatter.string(from: tripEndDate)
//
//        return startMonthString == endMonthString ?
//        "\(startMonthString) \(startDayString) - \(endDayString)" :
//        "\(startMonthString) \(startDayString) - \(endMonthString) \(endDayString)"
//
//    }
    
    var body: some View {
        
        HStack {
            
            // Image of Trip
            VStack {
                Image("umich")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color.yellow)
                
                //                Text("we need images ;-;\n\t- vivi <3").font(Font.caption)
            }
            .padding()
            
            Spacer()
            
            // Trip Details
            VStack {
                
                // Trip Name
                Text(self.tripName ?? "Current Trip")
                    .multilineTextAlignment(.center)
                    .font(Font.title)
                    .foregroundColor(Color.blue)
                
                // Trip Datess
                Text(self.tripStartDate ?? "") //self.getTripDateRange())
                    .font(Font.body)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            
        }
        .padding()
        .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1))
        .cornerRadius(8)
    }
}

struct RatingView: View {
    @Binding var landmark: Landmark // The rating value that the view is bound to

    var maximumRating = 5 // The maximum rating value
    var offImage: Image? // Image used when the star is not selected
    var onImage = Image(systemName: "star.fill") // Image used when the star is selected
    var offColor = Color.gray // Color used when the star is not selected
    var onColor = Color.yellow // Color used when the star is selected

    var body: some View {
        HStack{
            //Spacer()
            ForEach(1...maximumRating, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > landmark.rating ? offColor : onColor)
                    .scaleEffect(0.5)
                    .padding(.horizontal, -6)
            }
            Spacer()
        }
    }

    private func image(for number: Int) -> Image {
        if number > landmark.rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
}

struct ItinerarySingleEntryView: View {
    
    //@State var index: Int
    @State var landmark: newLandmark
    
    var body: some View {
        VStack{
            HStack {
                VStack {
                    // Landmark Name
                    TextField("", text: Binding (get: {landmark.landmark_name}, set: { _ in}))
                        .font(Font.title2)
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 1))
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
                    
                    // Optional Description Message
//                    TextField("", text: Binding (get: {landmark.message ?? ""}, set: { _ in}))
//                        .font(Font.body)
//                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1))
//                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
               }
                
//                Button(action: {
//                    landmark.favorite.toggle()
//
//                }) { // closure dynamically draws favorite star
//                    landmark.favorite ?
//                    Image(systemName: "star.fill")
//                        .foregroundColor(Color.yellow) :
//                    Image(systemName: "star")
//                        .foregroundColor(Color.blue)
//                }
            }
           // Text("", text: Binding (get: {landmark.trip_day}, set: { _ in}))
            Text("Day: \(landmark.trip_day)")
                .font(.system(size: 15))
                .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1))
                .frame(maxWidth: .infinity, alignment: .leading)
            //RatingView(landmark: $landmark)
        }
        .padding()
        .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1))
        .cornerRadius(8)
    }
    
    
}

struct ItinerarySingleEntryExpandedView: View {
    
    //@State var index: Int
    @State var landmark: newLandmark
    
    @ObservedObject var viewModel: NavigationControllerViewModel
   // @StateObject var itineraryEntries = UserItineraryStore.shared
    @StateObject var itineraryEntries = LandmarkStore.shared
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    
                    // Landmark Name
                    TextField("", text: Binding (get: {landmark.landmark_name}, set: { _ in}))
                        .font(Font.title2)
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 1))
                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
                    // Optional Description Message
//                    TextField("", text: Binding (get: {landmark.message ?? ""}, set: { _ in}))
//                        .font(Font.body)
//                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1))
//                        .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    
                }
                Spacer()
                
//                Button(action: {
//                    landmark.favorite.toggle()
//
//                }) { // closure dynamically draws favorite star
//                    landmark.favorite ?
//                    Image(systemName: "star.fill")
//                        .foregroundColor(Color.yellow) :
//                    Image(systemName: "star")
//                        .foregroundColor(Color.blue)
//                }
            }
            
            HStack {
                Button(action: {
                    viewModel.itineraryDirectNavigation(selected: landmark)
                }) {
                    Text("View on Map")
                        .font(Font.body)
                }
                .padding()
                .background(Color(red: 0, green: 0.5, blue: 0))
                .foregroundStyle(.white)
                .clipShape(Capsule())
                
                Spacer()
                
                Button(action: {
                    Task{
                        await itineraryEntries.removeLandmark(landmark: landmark)
                    }
                }) {
                    Text("Delete")
                        .font(Font.body)
                }
                .padding()
                .background(Color(red: 0.5, green: 0, blue: 0))
                .foregroundStyle(.white)
                .clipShape(Capsule())
                
                Spacer()
                
//                NavigationLink(destination: LandmarkView(viewModel: viewModel,
//                                                         landmark: $landmark)){
//                    Text("More...")
//                        .font(Font.body)
//                }
//                .padding()
//                .background(Color(.systemBlue))
//                .foregroundStyle(.white)
//                .clipShape(Capsule())
            }
           
        }
       
        .padding()
        .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1))
        .cornerRadius(8)
    }
}

//struct DayView: View {
//    @Binding var day: Int
//    @Binding var itineraryID: Int
//
//
//    @ObservedObject var viewModel: NavigationControllerViewModel
//    // moving a landmark around
//    @State var draggedLandmark: Landmark?
//
//    // expanding information on individual landmark
//    @State var expandedLandmark: Landmark?
//
//    @StateObject var itineraryEntries = UserItineraryStore.shared
//
//    @State var landmarks: [Landmark] = []
//
//    var body: some View {
//        // itinerary list
//        ScrollView(showsIndicators: false) {
//            VStack(spacing: 10) {
//                ForEach(Array(landmarks.enumerated()), id: \.element.id) { index, landmark in
//
//                    Group {
//                        if (self.expandedLandmark?.id == landmark.id)
//                        {
//                            ItinerarySingleEntryExpandedView(index: index, landmark: $landmarks[index], viewModel: viewModel, itineraryEntries: itineraryEntries)
//                        }
//                        else
//                        {
//                            ItinerarySingleEntryView(index: index, landmark: $landmarks[index])
//                        }
//                      }
//
//                        .onDrag {
//                            self.draggedLandmark = landmark
//                            return NSItemProvider()
//                        }
//                        .onDrop(
//                            of: [.text],
//                            delegate: ItineraryDropViewDelegate(
//                                destinationLandmark: landmark,
//                                landmarks: $landmarks,
//                                draggedLandmark: $draggedLandmark
//                            ))
//
//                        .onTapGesture(count: 1) {
//                            self.expandedLandmark = landmark
//                        }
//                }
//            }
//        }
//        .onAppear{
//            landmarks = getDay(day: day)
//            print("\(landmarks)")
//        }
//        .onChange(of: day, initial: true, {
//            landmarks = getDay(day: day)
//        })
//        .onChange(of: itineraryEntries.newLandmarks, initial: false, {
//            landmarks = getDay(day: day)
//        })
//        .refreshable {
//            // This refreshes the entire itinerary
//            await itineraryEntries.getTripDetails(itineraryID: itineraryID)
//            //this selects the places recommended for the day
//        }
//        .padding(.horizontal)
//    }
//
//    //Return Landmarks for a specific day
//    func getDay(day: Int)-> [newLandmark] {
//        var results: [newLandmark] = []
//        for landmark in itineraryEntries.newLandmarks {
//            if landmark.trip_day == day {
//                results.append(landmark)
//            }
//        }
//        return results
//    }
//
//}




struct ItineraryView: View {
    
    @State var days = [1,2,3,4,5,6,7, 9, 10, 11, 12]
    @State var selectedDay = 1
    
    @ObservedObject var viewModel: NavigationControllerViewModel
    @State var itineraryID: Int // Property to hold itinerary id
    @ObservedObject var userItineraryStore = UserItineraryStore.shared
    @State var it_name: String?
    @State var date: String?
    
    

    // moving a landmark around
    @State var draggedLandmark: newLandmark?
    
    // expanding information on individual landmark
    @State var expandedLandmark: newLandmark?
    
    @StateObject var itineraryEntries = LandmarkStore.shared
    
    @State var newDescription: String = ""
    
    @State var landmarks: [newLandmark] = []
    
    
    var body: some View {
        
        VStack {
            
            ItineraryHeaderView(tripName: $it_name, tripStartDate: $date)
            
            // this is to select days
//            ScrollView(.horizontal, showsIndicators: false){
//                HStack{
//                    Spacer()
//                    ForEach(days, id: \.self) { day in
//                        Button(action: {
//                            print("\(day) was tapped")
//                            selectedDay = day
//                        }) {
//                            Text("\(day)")
//                                .foregroundColor(.white)
//                                .padding()
//                                .background(Color.blue)
//                                .cornerRadius(10)
//                        }
//                        Spacer()
//                    }
//                }
//            }
//            Spacer()
            
//            struct newLandmark: Hashable, Decodable {
//                var it_id: Int
//                var landmark_name: String
//                var latitude: Double
//                var longitude: Double
//                var trip_day: Int
//            }

            //DayView(day: $selectedDay, viewModel: viewModel)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 5) {
                    ForEach(landmarks, id: \.id) { landmark in
                        Group{
                            if (self.expandedLandmark?.id == landmark.id) {
                                ItinerarySingleEntryExpandedView(landmark: landmark, viewModel: viewModel)
                            } else {
                                ItinerarySingleEntryView(landmark: landmark)
                            }
                        }
                        .onDrag {
                            self.draggedLandmark = landmark
                            return NSItemProvider()
                        }
                        .onDrop(
                            of: [.text],
                            delegate: ItineraryDropViewDelegate(
                                destinationLandmark: landmark,
                                landmarks: $landmarks,
                                draggedLandmark: $draggedLandmark
                            ))
                            .onTapGesture(count: 1) {
                                self.expandedLandmark = landmark
                            }
                    }
                }
            }
            Spacer()
            Text("Add new destation")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(titleCol)
//
//            TextField("Describe what you want to visit", text: $newDescription)
//                .autocapitalization(.none)
//                .foregroundColor(greyCol)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(lineWidth: 1)
//                        .foregroundColor(greyCol)
//                )
//                .padding(.horizontal, 40)
            
            HStack{
                    TextField("Which day would you like to add a destination to?", text: $newDescription)
                        .autocapitalization(.none)
                        .foregroundColor(greyCol)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 1)
                                .foregroundColor(greyCol)
                        )
                        .padding(.horizontal, 10)
                        Button(action: {
                            // Call the function to add landmark to itinerary
                            Task {
                                await UserItineraryStore.shared.addLandmarktoItinerary(itineraryID: itineraryID, day: newDescription)
                                await refreshData()

                            }
                        }) {
                            Image("arrow_right")
                                .resizable()
                                .frame(width: 30, height: 30)
                              //  .frame(alignment: .trailing)
                        }
                }
        }
        .onAppear{
            Task {
                await userItineraryStore.getTripDetails(itineraryID: itineraryID)
                landmarks = userItineraryStore.newLandmarks
                print("from itine view       ", landmarks)
            }
        }
        .refreshable {
            Task {
                await userItineraryStore.getTripDetails(itineraryID: itineraryID)
                landmarks = userItineraryStore.newLandmarks
            }
        }
        .background(backCol)
        Spacer()
        ChildNavController(viewModel: viewModel)
    }
    func refreshData() async {
            print("refreshing")
            await userItineraryStore.getTripDetails(itineraryID: itineraryID)
            landmarks = userItineraryStore.newLandmarks
        }
}
