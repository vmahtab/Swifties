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
      TextField("", text: $landmark.name)
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
  @StateObject var itineraryEntries = ItineraryEntries()
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 10) {
          ForEach(Array(itineraryEntries.entries.enumerated()), id: \.element.id) { index, landmark in
          ItineraryView(index: index, landmark: $itineraryEntries.entries[index])
              
            .onDrag {
              self.draggedLandmark = landmark
              return NSItemProvider()
            }
            .onDrop(
              of: [.text],
              delegate: ItineraryDropViewDelegate(
                destinationLandmark: landmark,
                landmarks: $itineraryEntries.entries,
                draggedLandmark: $draggedLandmark
              ))
            .onTapGesture(count: 2) {
                    itineraryEntries.entries.remove(at: index)
            }
        }
        
        Spacer()
      }

      .padding(.horizontal, 20)
    }
    .background(Color.black)
  }
}
