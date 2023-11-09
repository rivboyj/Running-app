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
}
