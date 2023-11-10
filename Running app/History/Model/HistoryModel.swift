//
//  HistoryModel.swift
//  Running app
//
//  Created by River on 11/9/23.
//

import Foundation



struct CompletedGoal: Identifiable {
    let id = UUID()
    let goalName: String
    let distanceInMiles: Double
    let pacePerMile: Time
    let duration: Time
}



