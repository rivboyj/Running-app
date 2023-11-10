//
//  goalModel.swift
//  Running app
//
//  Created by River on 11/1/23.
//

import Foundation
import SwiftUI

struct Time {
    let hours: Int
    let minutes: Int
    let seconds: Int

    init(hours: Int, minutes: Int, seconds: Int) {
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
}

struct Goal: Identifiable, Equatable {
    var id = UUID()
    var goalName: String
    var distanceInMiles: Double
    var pacePerMile: Time
    var duration: Time
}

// Ensure that 'Goal' conforms to 'Equatable'
extension Goal {
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        return lhs.id == rhs.id
    }
}
