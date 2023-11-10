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

    func addCompletedGoal(from goal: Goal) {
        let completed = CompletedGoal(goalName: goal.goalName, distanceInMiles: goal.distanceInMiles, pacePerMile: goal.pacePerMile, duration: goal.duration)
        completedGoals.append(completed)
    }
}


