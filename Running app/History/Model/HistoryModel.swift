//
//  HistoryModel.swift
//  Running app
//
//  Created by River on 11/9/23.
//

import Foundation


struct Time2 {
    let hours: Int
    let minutes: Int
    let seconds: Int

    init(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
}

struct CompletedGoal: Identifiable {
    let id = UUID()
    let goalName: String
    let distanceInMiles: Double
    let pacePerMile: Time2
    let duration: Time2
}



