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
    
    var body: some View {
        List(historyViewModel.completedGoals) { completedGoal in
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
        .navigationBarTitle("Completed Goals", displayMode: .inline)
    }
}
