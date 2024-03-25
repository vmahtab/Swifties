//
//  ItineraryView.swift
//  wanderhub
//
//  Created by Vivianna Mahtab on 3/17/24.
//

import Foundation
import SwiftUI
import _MapKit_SwiftUI


// TODO: remove this but im lazy /shrug
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
    
    let destinationLandmark: Landmark
    @Binding var landmarks: [Landmark]
    @Binding var draggedLandmark: Landmark?
    
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
    
    // TODO: build this struct?
    // @State tripInfo
    
    
    @State var tripName: String = "Paris"
    @State var tripStartDate: Date = getDateObject("11/11/2023", "00:00")
    @State var tripEndDate:   Date = getDateObject("11/15/2023", "00:00")
    
    // surprisingly complex, not inlining in View
    func getTripDateRange() -> String {
        
        let dateFormatter = DateFormatter()
        
        // get months
        dateFormatter.dateFormat = "LLLL"
        let startMonthString = dateFormatter.string(from: tripStartDate)
        let endMonthString   = dateFormatter.string(from: tripEndDate)
        
        dateFormatter.dateFormat = "dd"
        let startDayString = dateFormatter.string(from: tripStartDate)
        let endDayString = dateFormatter.string(from: tripEndDate)
        
        return startMonthString == endMonthString ?
        "\(startMonthString) \(startDayString) - \(endDayString)" :
        "\(startMonthString) \(startDayString) - \(endMonthString) \(endDayString)"
        
    }
    
    var body: some View {
        
        HStack {
            
            // Image of Trip
            VStack {
                Image(systemName: "smiley")
                    .resizable()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(Color.yellow)
                
                Text("we need images ;-;\n\t- vivi <3").font(Font.caption)
            }
            .padding()
            
            Spacer()
            
            // Trip Details
            VStack {
                
                // Trip Name
                Text(self.tripName)
                    .multilineTextAlignment(.center)
                    .font(Font.title)
                    .foregroundColor(Color.blue)
                
                // Trip Datess
                Text(self.getTripDateRange())
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

struct ItinerarySingleEntryView: View {
    
    @State var index: Int
    @Binding var landmark: Landmark
    
    var body: some View {
        HStack {
            VStack {
                
                // Landmark Name
                TextField("", text: Binding (get: {landmark.name ?? ""}, set: { _ in}))
                    .font(Font.title2)
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 1))
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                // Optional Description Message
                TextField("", text: Binding (get: {landmark.message ?? ""}, set: { _ in}))
                    .font(Font.body)
                    .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7, opacity: 1))
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            }
            Spacer()
            
            Button(action: {
                landmark.favorite.toggle()
                
            }) { // closure dynamically draws favorite star
                landmark.favorite ?
                Image(systemName: "star.fill")
                    .foregroundColor(Color.yellow) :
                Image(systemName: "star")
                    .foregroundColor(Color.blue)
            }
        }
        .padding()
        .background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1))
        .cornerRadius(8)
    }
}

//struct ItineraryEntriesView : View {
    
    //    @State var draggedLandmark: Landmark?
    //    @StateObject var itineraryEntries = LandmarkStore.shared
    //
    //    var body: some View {
    //
    //        // itinerary list
    //        ScrollView(showsIndicators: false) {
    //            VStack(spacing: 10) {
    //                ForEach(Array(itineraryEntries.landmarks.enumerated()), id: \.element.id) { index, landmark in
    //                    ItinerarySingleEntryView(index: index, landmark: $itineraryEntries.landmarks[index])
    //
    //                        .onDrag {
    //                            self.draggedLandmark = landmark
    //                            return NSItemProvider()
    //                        }
    //                        .onDrop(
    //                            of: [.text],
    //                            delegate: ItineraryDropViewDelegate(
    //                                destinationLandmark: landmark,
    //                                landmarks: $itineraryEntries.landmarks,
    //                                draggedLandmark: $draggedLandmark
    //                            ))
    //
    //                        .onTapGesture(count: 1) {
    //                            // TODO: make MapView.selected() with $landmark
    //                            // TODO: change nav to mapview
    //                        }
    //
    //                        .onTapGesture(count: 2) {
    //                            itineraryEntries.removeLandmark(index: index)
    //
    //                        }
    //                }
    //            }
    //        }
    //        .refreshable {
    //            await itineraryEntries.getLandmarks()
    //        }
    //        .padding(.horizontal)
    //
    //    }
    
//}

struct ItineraryView: View {
    
    @ObservedObject var viewModel: NavigationControllerViewModel
    
    @State var draggedLandmark: Landmark?
    @StateObject var itineraryEntries = LandmarkStore.shared
    
    var body: some View {
        
        VStack {
            
            ItineraryHeaderView()
            Spacer()
            
            // itinerary list
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ForEach(Array(itineraryEntries.landmarks.enumerated()), id: \.element.id) { index, landmark in
                        ItinerarySingleEntryView(index: index, landmark: $itineraryEntries.landmarks[index])
                        
                            .onDrag {
                                self.draggedLandmark = landmark
                                return NSItemProvider()
                            }
                            .onDrop(
                                of: [.text],
                                delegate: ItineraryDropViewDelegate(
                                    destinationLandmark: landmark,
                                    landmarks: $itineraryEntries.landmarks,
                                    draggedLandmark: $draggedLandmark
                                ))
                        
//                            .onTapGesture(count: 1) {
//                                NavigationView(content: {
//                                    NavigationLink(destination: Text("Destination")) { /*@START_MENU_TOKEN@*/Text("Navigate")/*@END_MENU_TOKEN@*/ }
//                                })
//                            }
                        
                            .onTapGesture(count: 2) {
                                itineraryEntries.removeLandmark(index: index)
                                
                            }
                    }
                }
            }
            .refreshable {
                await itineraryEntries.getLandmarks()
            }
            .padding(.horizontal)
            
            
        }
        .background(backCol)
        Spacer()
        ChildNavController(viewModel: viewModel)
    }
    
}

//    var body: some View {
//
//        // Full Itinerary
//        VStack {
//            ItineraryHeaderView()
//            Spacer()
//            ItineraryEntriesView()
//        }
//        .background(backCol)
//        Spacer()
//        ChildNavController(viewModel: viewModel)
//
//    }
