//
//  GoalsView.swift
//  Running app
//
//  Created by River on 10/27/23.
//

import Foundation
import SwiftUI


struct GoalsView: View {
    @ObservedObject var viewModel = GoalViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                HStack(spacing: 10) {
                    NavigationLink(destination: DurationGoalView(viewModel: viewModel)) {
                        buttonContent(title: "Duration", imageName: "clock")
                            .frame(width: geometry.size.width / 5 - 10)
                    }
                    
                    NavigationLink(destination: MileGoalView(viewModel: viewModel)) {
                        buttonContent(title: "Mile", imageName: "trophy")
                            .frame(width: geometry.size.width / 5 - 10)
                    }
                    
                    NavigationLink(destination: DistanceGoalView(viewModel: viewModel)) {
                        buttonContent(title: "Distance", imageName: "distance")
                            .frame(width: geometry.size.width / 5 - 10)
                    }
                    
                    NavigationLink(destination: SprintGoalView(viewModel: viewModel)) {
                        buttonContent(title: "Sprint", imageName: "speed")
                            .frame(width: geometry.size.width / 5 - 10)
                    }
                    
                    NavigationLink(destination: CustomGoalView(viewModel: viewModel)) {
                        buttonContent(title: "Custom", imageName: "gears")
                            .frame(width: geometry.size.width / 5 - 10)
                    }
                }
                .offset(y: 600) // Adjust as per your needs
            }
        }
    }
    
    func buttonContent(title: String, imageName: String? = nil) -> some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(Color.blue)
                    .frame(width: 60, height: 60) // Adjust the size as needed
                if let image = imageName {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30) // Adjust size accordingly
                } else {
                    Text(title)
                        .foregroundColor(Color.white)
                }
            }
            Text(title)
                .font(.system(size: 12)) // Adjust the font size as needed
        }
    }
}

struct DurationGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    
    @State private var goalName: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0

    var body: some View {
        Form {
            TextField("Goal Name", text: $goalName)
            
            Picker("Hours", selection: $hours) {
                ForEach(0..<24) { hour in
                    Text("\(hour) hr")
                }
            }

            Picker("Minutes", selection: $minutes) {
                ForEach(0..<60) { minute in
                    Text("\(minute) min")
                }
            }

            Picker("Seconds", selection: $seconds) {
                ForEach(0..<60) { second in
                    Text("\(second) sec")
                }
            }

            Button("Submit") {
                let time = Time(hours: hours, minutes: minutes, seconds: seconds)
                let goal = Goal(goalName: goalName, distanceInMiles: 0, pacePerMile: Time(hours: 0, minutes: 0, seconds: 0), duration: time)
                viewModel.goalsArr.append(goal)
            }
        }
    }
}

struct MileGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    
    @State private var goalName: String = ""
    @State private var paceHours: Int = 0
    @State private var paceMinutes: Int = 0
    @State private var paceSeconds: Int = 0

    var body: some View {
        Form {
            TextField("Goal Name", text: $goalName)
            
            Picker("Hours", selection: $paceHours) {
                ForEach(0..<24) { hour in
                    Text("\(hour) hr")
                }
            }

            Picker("Minutes", selection: $paceMinutes) {
                ForEach(0..<60) { minute in
                    Text("\(minute) min")
                }
            }

            Picker("Seconds", selection: $paceSeconds) {
                ForEach(0..<60) { second in
                    Text("\(second) sec")
                }
            }

            Button("Submit") {
                let pace = Time(hours: paceHours, minutes: paceMinutes, seconds: paceSeconds)
                let goal = Goal(goalName: goalName, distanceInMiles: 0, pacePerMile: pace, duration: Time(hours: 0, minutes: 0, seconds: 0))
                viewModel.goalsArr.append(goal)
            }
        }
    }
}


struct DistanceGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    
    @State private var goalName: String = ""
    @State private var distance: Double = 0.0

    var body: some View {
        Form {
            TextField("Goal Name", text: $goalName)
            
            Picker("Distance in Miles", selection: $distance) {
                ForEach(0..<101) { mile in
                    Text("\(mile) mi")
                }
            }

            Button("Submit") {
                let goal = Goal(goalName: goalName, distanceInMiles: distance, pacePerMile: Time(hours: 0, minutes: 0, seconds: 0), duration: Time(hours: 0, minutes: 0, seconds: 0))
                viewModel.goalsArr.append(goal)
            }
        }
    }
}


struct SprintGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    
    @State private var goalName: String = ""
    @State private var distance: Double = 0.0
    @State private var paceHours: Int = 0
    @State private var paceMinutes: Int = 0
    @State private var paceSeconds: Int = 0

    var body: some View {
        Form {
            TextField("Goal Name", text: $goalName)
            
            Picker("Distance in Miles", selection: $distance) {
                ForEach(0..<101) { mile in
                    Text("\(mile) mi")
                }
            }
            
            Picker("Hours", selection: $paceHours) {
                ForEach(0..<24) { hour in
                    Text("\(hour) hr")
                }
            }

            Picker("Minutes", selection: $paceMinutes) {
                ForEach(0..<60) { minute in
                    Text("\(minute) min")
                }
            }

            Picker("Seconds", selection: $paceSeconds) {
                ForEach(0..<60) { second in
                    Text("\(second) sec")
                }
            }

            Button("Submit") {
                let pace = Time(hours: paceHours, minutes: paceMinutes, seconds: paceSeconds)
                let goal = Goal(goalName: goalName, distanceInMiles: distance, pacePerMile: pace, duration: Time(hours: 0, minutes: 0, seconds: 0))
                viewModel.goalsArr.append(goal)
            }
        }
    }
}


struct CustomGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    
    @State private var goalName: String = ""
    @State private var distance: Double = 0.0
    @State private var paceHours: Int = 0
    @State private var paceMinutes: Int = 0
    @State private var paceSeconds: Int = 0
    @State private var durationHours: Int = 0
    @State private var durationMinutes: Int = 0
    @State private var durationSeconds: Int = 0

    init(viewModel: GoalViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Form {
            // Goal Name
            TextField("Goal Name", text: $goalName)
            
            // Distance in Miles
            Stepper(value: $distance, in: 0...100) {
                Text("Distance: \(distance, specifier: "%.1f") miles")
            }
            
            // Pace Per Mile
            Picker("Pace Hours", selection: $paceHours) {
                ForEach(0..<24) { hour in
                    Text("\(hour) hr")
                }
            }
            Picker("Pace Minutes", selection: $paceMinutes) {
                ForEach(0..<60) { minute in
                    Text("\(minute) min")
                }
            }
            Picker("Pace Seconds", selection: $paceSeconds) {
                ForEach(0..<60) { second in
                    Text("\(second) sec")
                }
            }
            
            // Duration
            Picker("Duration Hours", selection: $durationHours) {
                ForEach(0..<24) { hour in
                    Text("\(hour) hr")
                }
            }
            Picker("Duration Minutes", selection: $durationMinutes) {
                ForEach(0..<60) { minute in
                    Text("\(minute) min")
                }
            }
            Picker("Duration Seconds", selection: $durationSeconds) {
                ForEach(0..<60) { second in
                    Text("\(second) sec")
                }
            }
            
            Button("Submit") {
                let paceTime = Time(hours: paceHours, minutes: paceMinutes, seconds: paceSeconds)
                let durationTime = Time(hours: durationHours, minutes: durationMinutes, seconds: durationSeconds)
                let goal = Goal(goalName: goalName, distanceInMiles: distance, pacePerMile: paceTime, duration: durationTime)
                viewModel.goalsArr.append(goal)
            }
        }
    }
}
