//
//  HistoryViewModel.swift
//  Running app
//
//  Created by River on 11/9/23.
//

import Foundation
import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var completedGoals: [CompletedGoal] = []
    @Published var runs: [Run] = []

    func addCompletedGoal(from goal: Goal) {
        let completed = CompletedGoal(goalName: goal.goalName, distanceInMiles: goal.distanceInMiles, pacePerMile: goal.pacePerMile, duration: goal.duration)
        completedGoals.append(completed)
    }

    func addRun(_ run: Run) {
        runs.append(run)
    }
}
