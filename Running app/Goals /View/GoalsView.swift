//
//  GoalsView.swift
//  Running app
//
//  Created by River on 10/27/23.
//

import Foundation
import SwiftUI


enum ActiveAlert {
    case delete, complete, none
}

class GoalColorViewModel: ObservableObject {
    @Published var colorMap = [String: Color]()
    private var currentColorIndex = 0 // Maintain the current color index
    private let colors = [
        Color(hex: "006d77"),
        Color(hex: "83c5be"),
        Color(hex: "edf6f9"),
        Color(hex: "ffddd2"),
        Color(hex: "e29578"),
        Color(hex: "f0cf65")
    ]

    func color(for goalId: String) -> Color {
        if let color = colorMap[goalId] {
            return color
        } else {
            let selectedColor = colors[currentColorIndex % colors.count] // Get the color based on the current index
            currentColorIndex += 1 // Increment the current index for the next call
            colorMap[goalId] = selectedColor
            return selectedColor
        }
    }
}

// Main View
struct GoalsView: View {
    @ObservedObject var colorViewModel = GoalColorViewModel()
    @ObservedObject var viewModel = GoalViewModel()
    @ObservedObject var historyViewModel = HistoryViewModel()

    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .none
    @State private var activeGoal: Goal?

    var body: some View {
        NavigationView {
            VStack {
                // Remove the background color from the ScrollView
                ScrollView {
                    VStack {
                        ForEach(viewModel.goalsArr.indices, id: \.self) { index in
                            GoalRow(
                                goal: viewModel.goalsArr[index],
                                colorViewModel: colorViewModel,
                                deleteAction: {
                                    self.activeGoal = viewModel.goalsArr[index]
                                    self.activeAlert = .delete
                                    self.showAlert = true
                                },
                                completeAction: {
                                    self.activeGoal = viewModel.goalsArr[index]
                                    self.activeAlert = .complete
                                    self.showAlert = true
                                }
                            )
                            .padding(.horizontal)  // Adjust padding here
                            .background(colorViewModel.color(for: viewModel.goalsArr[index].id.uuidString)) // Use the color from the colorViewModel
                            .cornerRadius(8)
                            .onTapGesture {
                                // Handle row tap action if needed
                            }
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    switch activeAlert {
                    case .delete:
                        return Alert(
                            title: Text("Delete Goal"),
                            message: Text("Are you sure you want to delete this goal?"),
                            primaryButton: .destructive(Text("Delete"), action: {
                                if let deleteGoal = self.activeGoal, let index = self.viewModel.goalsArr.firstIndex(where: { $0.id == deleteGoal.id }) {
                                    self.viewModel.goalsArr.remove(at: index)
                                }
                                self.activeGoal = nil
                                self.activeAlert = .none
                            }),
                            secondaryButton: .cancel {
                                self.activeGoal = nil
                                self.activeAlert = .none
                            }
                        )
                    case .complete:
                        return Alert(
                            title: Text("Complete Goal"),
                            message: Text("Are you sure you want to mark this goal as complete?"),
                            primaryButton: .default(Text("Complete"), action: {
                                if let completeGoal = self.activeGoal {
                                    self.historyViewModel.addCompletedGoal(from: completeGoal)
                                    if let index = self.viewModel.goalsArr.firstIndex(where: { $0.id == completeGoal.id }) {
                                        self.viewModel.goalsArr.remove(at: index)
                                    }
                                }
                                self.activeGoal = nil
                                self.activeAlert = .none
                            }),
                            secondaryButton: .cancel {
                                self.activeGoal = nil
                                self.activeAlert = .none
                            }
                        )
                    case .none:
                        return Alert(title: Text("No action"))
                    }
                }

                Spacer()

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
// GoalRow View
struct GoalRow: View {
    let goal: Goal
    @ObservedObject var colorViewModel: GoalColorViewModel
    let deleteAction: () -> Void
    let completeAction: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) { // Add spacing between elements
                Text(goal.goalName)
                    .font(.headline)
                    .lineLimit(1) // Limit the text to one line
                HStack(spacing: 8) { // Add spacing between elements
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
            Button(action: deleteAction) {
                Image(systemName: "xmark.circle")
                    .foregroundColor(.red)
            }
            Button(action: completeAction) {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .frame(maxWidth: 350, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
        .background(colorViewModel.color(for: goal.id.uuidString)) // Use the color from the colorViewModel
    }
}
// Extension for Color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xff0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00ff00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000ff) / 255.0
        
        self.init(red: r, green: g, blue: b)
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
            VStack {
                Text("Time")
                    .font(.headline)
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
            }
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
            VStack {
                Text("Time")
                    .font(.headline)
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
            }
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
            VStack {
                Text("Distance")
                    .font(.headline)
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
            VStack {
                Text("Distance")
                    .font(.headline)
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
            }
            VStack {
                Text("Pace")
                    .font(.headline)
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
