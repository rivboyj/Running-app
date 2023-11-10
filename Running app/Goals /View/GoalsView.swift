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
    @ObservedObject var historyViewModel = HistoryViewModel()
    @State private var showingDeleteAlert = false
    @State private var showingCompleteAlert = false
    @State private var activeGoal: Goal?

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
                                self.activeGoal = goal
                                self.showingDeleteAlert = true
                            }) {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.red)
                            }
                            Button(action: {
                                self.activeGoal = goal
                                self.showingCompleteAlert = true
                            }) {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .onDelete(perform: deleteGoal)
                }
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Delete Goal"),
                        message: Text("Are you sure you want to delete this goal?"),
                        primaryButton: .destructive(Text("Delete"), action: {
                            if let goal = activeGoal, let index = viewModel.goalsArr.firstIndex(where: { $0.id == goal.id }) {
                                viewModel.goalsArr.remove(at: index)
                            }
                            activeGoal = nil
                            showingDeleteAlert = false
                        }),
                        secondaryButton: .cancel {
                            activeGoal = nil
                            showingDeleteAlert = false
                        }
                    )
                }
                .alert(isPresented: $showingCompleteAlert) {
                    Alert(
                        title: Text("Completeeee Goal"),
                        message: Text("Are you sure you want to mark this goal as complete?"),
                        primaryButton: .default(Text("Complete"), action: {
                            if let goal = activeGoal {
                                historyViewModel.addCompletedGoal(from: goal)
                                if let index = viewModel.goalsArr.firstIndex(where: { $0.id == goal.id }) {
                                    viewModel.goalsArr.remove(at: index)
                                }
                            }
                            activeGoal = nil
                            showingCompleteAlert = false
                        }),
                        secondaryButton: .cancel {
                            activeGoal = nil
                            showingCompleteAlert = false
                        }
                    )
                }

                HStack(spacing: 10) {
                    NavigationLink(destination: DurationGoalView(viewModel: viewModel)) {
                        buttonContent(title: "Duration", imageName: "clock")
                    }
                    NavigationLink(destination: MileGoalView(viewModel: viewModel)) {
                        buttonContent(title: "Mile", imageName: "trophy")
                    }
                    NavigationLink(destination: DistanceGoalView(viewModel: viewModel)) {
                        buttonContent(title: "Distance", imageName: "map")
                    }
                    NavigationLink(destination: SprintGoalView(viewModel: viewModel)) {
                        buttonContent(title: "Sprint", imageName: "hare")
                    }
                    NavigationLink(destination: CustomGoalView(viewModel: viewModel)) {
                        buttonContent(title: "Custom", imageName: "slider.horizontal.3")
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(UIColor.systemGroupedBackground))

            }
            .navigationBarTitle("Goals", displayMode: .large)
        }
    }

    private func deleteGoal(at offsets: IndexSet) {
        viewModel.goalsArr.remove(atOffsets: offsets)
    }

    private func buttonContent(title: String, imageName: String) -> some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(8)
                .background(Circle().fill(Color.blue))
                .foregroundColor(.white)
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
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
