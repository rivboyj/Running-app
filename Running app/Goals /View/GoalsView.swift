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
            VStack {
                List {
                    ForEach(viewModel.goalsArr) { goal in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(goal.goalName).font(.headline)
                                HStack {
                                    if goal.distanceInMiles > 0 {
                                        Text("Distance: \(goal.distanceInMiles, specifier: "%.2f") miles")
                                    }
                                    if goal.pacePerMile.hours > 0 || goal.pacePerMile.minutes > 0 || goal.pacePerMile.seconds > 0 {
                                        Text("Pace: \(goal.pacePerMile.hours)h \(goal.pacePerMile.minutes)m \(goal.pacePerMile.seconds)s per mile")
                                    }
                                    if goal.duration.hours > 0 || goal.duration.minutes > 0 || goal.duration.seconds > 0 {
                                        Text("Duration: \(goal.duration.hours)h \(goal.duration.minutes)m \(goal.duration.seconds)s")
                                    }
                                }
                            }
                            Spacer()
                            Button(action: {
                                if let index = viewModel.goalsArr.firstIndex(where: { $0.id == goal.id }) {
                                    viewModel.goalsArr.remove(at: index)
                                }
                            }) {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .onDelete(perform: deleteGoal)
                }
                
                Spacer()

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
                    .offset(y: geometry.size.height / 2)
                }
            }
            .navigationBarTitle("Goals", displayMode: .large)
            .navigationBarHidden(false)
        }
    }
    
    func deleteGoal(at offsets: IndexSet) {
        viewModel.goalsArr.remove(atOffsets: offsets)
    }
    
    func buttonContent(title: String, imageName: String? = nil) -> some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(Color.blue)
                    .frame(width: 60, height: 60)
                if let imageName = imageName, let image = UIImage(named: imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                } else {
                    Text(title.prefix(1))
                        .foregroundColor(Color.white)
                        .font(.title)
                }
            }
            Text(title)
                .font(.system(size: 12))
        }
    }
}
struct DurationGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var goalName: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0

    var body: some View {
        Form {
            TextField("Goal Name", text: $goalName)
            HStack {
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24, id: \.self) { hour in
                        Text("\(hour) hour\(hour == 1 ? "" : "s")").tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
                Picker("Minutes", selection: $minutes) {
                    ForEach(0..<60, id: \.self) { minute in
                        Text("\(minute) min").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
            }
            .compositingGroup()
            .frame(height: 150)
            Button("Submit") {
                let durationTime = Time(hours: hours, minutes: minutes, seconds: 0)
                let goal = Goal(goalName: goalName, distanceInMiles: 0, pacePerMile: Time(hours: 0, minutes: 0, seconds: 0), duration: durationTime)
                viewModel.goalsArr.append(goal)
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// MileGoalView with 'presentationMode' to dismiss the view
struct MileGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var goalName: String = ""
    @State private var paceHours: Int = 0
    @State private var paceMinutes: Int = 0

    var body: some View {
        Form {
            TextField("Goal Name", text: $goalName)
            HStack {
                Picker("Hours", selection: $paceHours) {
                    ForEach(0..<24, id: \.self) { hour in
                        Text("\(hour) hr").tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
                Picker("Minutes", selection: $paceMinutes) {
                    ForEach(0..<60, id: \.self) { minute in
                        Text("\(minute) min").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
            }
            .compositingGroup()
            .frame(height: 150)
            Button("Submit") {
                let pace = Time(hours: paceHours, minutes: paceMinutes, seconds: 0)
                let goal = Goal(goalName: goalName, distanceInMiles: 0, pacePerMile: pace, duration: Time(hours: 0, minutes: 0, seconds: 0))
                viewModel.goalsArr.append(goal)
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}


struct DistanceGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var goalName: String = ""
    @State private var miles: Int = 0
    @State private var fraction: Double = 0.0

    var body: some View {
        Form {
            TextField("Goal Name", text: $goalName)
            HStack {
                Picker("Miles", selection: $miles) {
                    ForEach(0..<101, id: \.self) { mile in
                        Text("\(mile) mi").tag(mile)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
                Picker("Fraction", selection: $fraction) {
                    ForEach(Array(stride(from: 0.0, to: 1.0, by: 0.1)), id: \.self) { frac in
                        Text("\(frac, specifier: "%.1f") mi").tag(frac)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
            }
            Button("Submit") {
                let totalDistance = Double(miles) + fraction
                let goal = Goal(goalName: goalName, distanceInMiles: totalDistance, pacePerMile: Time(hours: 0, minutes: 0, seconds: 0), duration: Time(hours: 0, minutes: 0, seconds: 0))
                viewModel.goalsArr.append(goal)
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

// SprintGoalView with 'presentationMode' to dismiss the view
struct SprintGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var goalName: String = ""
    @State private var miles: Int = 0
    @State private var fraction: Double = 0.0
    @State private var paceHours: Int = 0
    @State private var paceMinutes: Int = 0

    var body: some View {
        Form {
            TextField("Goal Name", text: $goalName)
            HStack {
                Picker("Miles", selection: $miles) {
                    ForEach(0..<101, id: \.self) { mile in
                        Text("\(mile) mi").tag(mile)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
                Picker("Fraction", selection: $fraction) {
                    ForEach(Array(stride(from: 0.0, to: 1.0, by: 0.1)), id: \.self) { frac in
                        Text("\(frac, specifier: "%.1f")").tag(frac)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
            }
            HStack {
                Picker("Pace Hours", selection: $paceHours) {
                    ForEach(0..<24, id: \.self) { hour in
                        Text("\(hour) hr").tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
                Picker("Pace Minutes", selection: $paceMinutes) {
                    ForEach(0..<60, id: \.self) { minute in
                        Text("\(minute) min").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
            }
            Button("Submit") {
                let totalDistance = Double(miles) + fraction
                let paceTime = Time(hours: paceHours, minutes: paceMinutes, seconds: 0)
                let goal = Goal(goalName: goalName, distanceInMiles: totalDistance, pacePerMile: paceTime, duration: Time(hours: 0, minutes: 0, seconds: 0))
                viewModel.goalsArr.append(goal)
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct CustomGoalView: View {
    @ObservedObject var viewModel: GoalViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var goalName: String = ""
    @State private var miles: Int = 0
    @State private var fraction: Double = 0.0
    @State private var paceHours: Int = 0
    @State private var paceMinutes: Int = 0
    @State private var durationHours: Int = 0
    @State private var durationMinutes: Int = 0

    var body: some View {
        Form {
            TextField("Goal Name", text: $goalName)
            HStack {
                Picker("Miles", selection: $miles) {
                    ForEach(0..<101, id: \.self) { mile in
                        Text("\(mile) mi").tag(mile)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
                Picker("Fraction", selection: $fraction) {
                    ForEach(Array(stride(from: 0.0, to: 1.0, by: 0.1)), id: \.self) { frac in
                        Text("\(frac, specifier: "%.1f")").tag(frac)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
            }
            HStack {
                Picker("Pace Hours", selection: $paceHours) {
                    ForEach(0..<24, id: \.self) { hour in
                        Text("\(hour) hr").tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
                Picker("Pace Minutes", selection: $paceMinutes) {
                    ForEach(0..<60, id: \.self) { minute in
                        Text("\(minute) min").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
            }
            HStack {
                Picker("Duration Hours", selection: $durationHours) {
                    ForEach(0..<24, id: \.self) { hour in
                        Text("\(hour) hr").tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
                Picker("Duration Minutes", selection: $durationMinutes) {
                    ForEach(0..<60, id: \.self) { minute in
                        Text("\(minute) min").tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 100, height: 150)
                .clipped()
            }
            Button("Submit") {
                let totalDistance = Double(miles) + fraction
                let paceTime = Time(hours: paceHours, minutes: paceMinutes, seconds: 0)
                let durationTime = Time(hours: durationHours, minutes: durationMinutes, seconds: 0)
                let goal = Goal(goalName: goalName, distanceInMiles: totalDistance, pacePerMile: paceTime, duration: durationTime)
                viewModel.goalsArr.append(goal)
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
