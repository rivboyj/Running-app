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

struct Goal: Identifiable {
    let id = UUID()
    let goalName: String
    let distanceInMiles: Double
    let pacePerMile: Time
    let duration: Time
}
