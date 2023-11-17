//
//  HistoryView.swift
//  Running app
//
//  Created by River on 10/27/23.
//

import Foundation
import SwiftUI

struct HistoryView: View {
    @ObservedObject var historyViewModel: HistoryViewModel
    @State private var selectedDate = Date()

    var body: some View {
        List {
            // Section for Completed Goals
            Section(header: Text("Completed Goals")) {
                ForEach(historyViewModel.completedGoals) { completedGoal in
                    VStack(alignment: .leading) {
                        Text(completedGoal.goalName).font(.headline)
                        HStack {
                            if completedGoal.distanceInMiles > 0 {
                                Text("Distance: \(completedGoal.distanceInMiles, specifier: "%.2f") miles")
                            }
                            if completedGoal.pacePerMile.hours > 0 || completedGoal.pacePerMile.minutes > 0 || completedGoal.pacePerMile.seconds > 0 {
                                Text("Pace: \(completedGoal.pacePerMile.hours)h \(completedGoal.pacePerMile.minutes)m \(completedGoal.pacePerMile.seconds)s per mile")
                            }
                            if completedGoal.duration.hours > 0 || completedGoal.duration.minutes > 0 || completedGoal.duration.seconds > 0 {
                                Text("Duration: \(completedGoal.duration.hours)h \(completedGoal.duration.minutes)m \(completedGoal.duration.seconds)s")
                            }
                        }
                    }
                }
            }

            // Calendar and Runs Section
            Section(header: Text("Runs Calendar")) {
                CalendarView(selectedDate: $selectedDate)

                ForEach(historyViewModel.runs.filter { isSameDay($0.date, selectedDate) }) { run in
                    VStack(alignment: .leading) {
                        Text(run.goalName).font(.headline)
                        HStack {
                            Text("Distance: \(run.distanceInMiles, specifier: "%.2f") miles")
                            Text("Duration: \(run.duration.hours)h \(run.duration.minutes)m \(run.duration.seconds)s")
                        }
                    }
                }
            }
        }
        .navigationBarTitle("History", displayMode: .inline)
    }

    private func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

// Calendar View
struct CalendarView: View {
    @Binding var selectedDate: Date

    var body: some View {
        DatePicker(
            "Select Date",
            selection: $selectedDate,
            displayedComponents: .date
        )
        .datePickerStyle(GraphicalDatePickerStyle())
        .padding()
    }
}
