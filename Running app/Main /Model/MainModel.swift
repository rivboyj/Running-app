//
//  MainViewModel.swift
//  Running app
//
//  Created by River on 11/15/23.
//
import Foundation
import SwiftUI



struct Run: Identifiable, Equatable {
    var id = UUID()
    var goalName: String
    var distanceInMiles: Double
    var pacePerMile: Time
    var duration: Time
    var date: Date = Date()
}

// Ensure that 'Goal' conforms to 'Equatable'
extension Run {
    static func == (lhs: Run, rhs:Run) -> Bool {
        return lhs.id == rhs.id
    }
}
