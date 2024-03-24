//
//  Calendar.swift
//  wanderhub
//
//  Created by Alexey Kovalenko on 3/23/24.
//

import UIKit
import FSCalendar
import SwiftUI

struct FSCalendarWrapper: UIViewRepresentable {
    @Binding var selectedDates: [Date]
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.allowsMultipleSelection = true  // Enable multiple selection
        calendar.dataSource = context.coordinator
        calendar.delegate = context.coordinator
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // Synchronize FSCalendar's selection with selectedDates
        uiView.selectedDates.forEach { uiView.deselect($0) }
        selectedDates.forEach { uiView.select($0) }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDataSource, FSCalendarDelegate {
        var parent: FSCalendarWrapper
        
        init(_ parent: FSCalendarWrapper) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            // Simplified example: select a start and end date
            if parent.selectedDates.count == 2 {
                // If two dates are already selected, reset and select the new date
                parent.selectedDates.removeAll()
            }
            parent.selectedDates.append(date)
            if parent.selectedDates.count == 2 {
                // Sort to ensure the start date comes before the end date
                parent.selectedDates.sort()
                // Optionally, fill in the range between start and end dates
                fillRange(calendar: calendar)
            }
        }
        
        func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
            if let index = parent.selectedDates.firstIndex(of: date) {
                parent.selectedDates.remove(at: index)
            }
        }
        
        // This function illustrates filling in the dates between the start and end date
        private func fillRange(calendar: FSCalendar) {
            guard parent.selectedDates.count == 2,
                  let startDate = parent.selectedDates.first,
                  let endDate = parent.selectedDates.last else { return }
            
            var currentDate = startDate
            while currentDate < endDate {
                guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else { break }
                currentDate = nextDay
                if !parent.selectedDates.contains(currentDate) {
                    parent.selectedDates.append(currentDate)
                    calendar.select(currentDate)
                }
            }
        }
    }
}
    
    
struct CalendarView: View {
    @ObservedObject var viewModel: NavigationControllerViewModel
    @State private var selectedDates = [Date]()
    
    var body: some View {
        VStack {
            Text("Selected Dates: \(selectedDates.count)")
            FSCalendarWrapper(selectedDates: $selectedDates)
                .frame(height: 300)
                .padding()
        }
    }
}
