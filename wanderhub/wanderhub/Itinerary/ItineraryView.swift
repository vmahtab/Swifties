//
//  ItineraryView.swift
//  wanderhub
//
//  Created by Vivianna Mahtab on 3/17/24.
//

import Foundation
import SwiftUI

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

struct ItineraryView: View {
  
  @State var index: Int
  @Binding var landmark: Landmark
  
  var body: some View {
    HStack {
      TextField("", text: Binding(
        get: { landmark.name ?? ""},
        set: {_ in}))
            .disabled(true)
      Spacer()
    }
    .font(Font.title)
    .padding()
    .background(Color.orange)
    .cornerRadius(8)
  }
}

struct ItinView: View {
  @State var draggedLandmark: Landmark?
@StateObject var itineraryEntries = LandmarkStore.shared
    @ObservedObject var viewModel: NavigationControllerViewModel
  
  var body: some View {
      VStack {
          ScrollView(showsIndicators: false) {
              VStack(spacing: 10) {
                  ForEach(Array(itineraryEntries.landmarks.enumerated()), id: \.element.id) { index, landmark in
                      ItineraryView(index: index, landmark: $itineraryEntries.landmarks[index])
                      
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
                          .onTapGesture(count: 2) {
                              itineraryEntries.removeLandmard(index: index)
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
}


