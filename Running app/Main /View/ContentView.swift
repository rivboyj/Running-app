//
//  ContentView.swift
//  Running app
//
//  Created by River on 10/27/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var selectedTab = 1
    let mainViewModel = MainViewModel() // Shared instance of MainViewModel
    let historyViewModel = HistoryViewModel() 
    var body: some View {
        TabView(selection: $selectedTab) {
            GoalsView(viewModel: GoalViewModel(), historyViewModel: historyViewModel)
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
                .tag(0)
            
            HomeView(mainViewModel: mainViewModel, historyViewModel: historyViewModel)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)
            
            // Assuming you have a HistoryView
            HistoryView(historyViewModel: historyViewModel)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(2)
        }
    }
}

class RunColorViewModel: ObservableObject {
    @Published var colorMap = [UUID: Color]()
    private var currentColorIndex = 0
    private let colors = [
        Color(hex: "006d77"),
        Color(hex: "83c5be"),
        Color(hex: "edf6f9"),
        Color(hex: "ffddd2"),
        Color(hex: "e29578"),
        Color(hex: "f0cf65")
    ]

    func color(for runId: UUID) -> Color {
        if let color = colorMap[runId] {
            return color
        } else {
            let selectedColor = colors[currentColorIndex % colors.count]
            currentColorIndex += 1
            colorMap[runId] = selectedColor
            return selectedColor
        }
    }
}
struct HomeView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var historyViewModel: HistoryViewModel
    @ObservedObject var runColorViewModel = RunColorViewModel()
    @State private var streak: Int = 0
    @State private var showAlert = false
    @State private var runToDelete: Run?

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ZStack {
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                        Text("\(streak)")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, 20)

                NavigationLink(destination: AddRunView(mainViewModel: mainViewModel, historyViewModel: historyViewModel)) {
                    Text("Add a Run")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                Text("Today's Runs:")
                    .font(.title2)
                    .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 10) { // This ensures there's space between each run entry
                        ForEach(mainViewModel.runArr.filter { Calendar.current.isDateInToday($0.date) }) { run in
                            VStack(alignment: .leading, spacing: 4) { // Added spacing for internal VStack elements
                                Text(run.goalName)
                                    .padding([.top, .horizontal])
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                if run.distanceInMiles > 0 {
                                    Text("\(run.distanceInMiles, specifier: "%.2f") mi")
                                        .padding(.horizontal)
                                }

                                if run.duration.hours > 0 || run.duration.minutes > 0 {
                                    Text("\(run.duration.hours) hr \(run.duration.minutes) min")
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.vertical, 8) // Added padding for top and bottom
                            .background(runColorViewModel.color(for: run.id))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
                .background(Color(UIColor.systemGroupedBackground))
                .padding(.bottom, 10) // Adds space at the bottom of the ScrollView
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Run"),
                    message: Text("Are you sure you want to delete this run?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let runToDelete = self.runToDelete, let index = self.mainViewModel.runArr.firstIndex(of: runToDelete) {
                            self.mainViewModel.runArr.remove(at: index)
                            self.runToDelete = nil // Reset the state after deletion
                        }
                        self.showAlert = false // Dismiss the alert after the action
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
    private func deleteRun(at offsets: IndexSet) {
        offsets.forEach { index in
            mainViewModel.runArr.remove(at: index)
        }
    }
}


struct AddRunView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var historyViewModel: HistoryViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var goalName: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var miles: Int = 0
    @State private var fractionMiles: Double = 0.0
    @State private var runDate: Date = Date()

    var body: some View {
        Form {
            Section(header: Text("Run Details")) {
                TextField("Run Name", text: $goalName)

                DatePicker("Run Date", selection: $runDate, displayedComponents: .date)

                VStack {
                    Text("Time").font(.headline)
                    HStack {
                        Picker("Hours", selection: $hours) {
                            ForEach(0..<24, id: \.self) { hour in
                                Text("\(hour) hr").tag(hour)
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
                }

                VStack {
                    Text("Distance").font(.headline)
                    HStack {
                        Picker("Miles", selection: $miles) {
                            ForEach(0..<101, id: \.self) { mile in
                                Text("\(mile) mi").tag(mile)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 150)
                        .clipped()

                        Picker("Fraction", selection: $fractionMiles) {
                            ForEach(Array(stride(from: 0.0, to: 1.0, by: 0.1)), id: \.self) { frac in
                                Text("\(frac, specifier: "%.1f") mi").tag(frac)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 150)
                        .clipped()
                    }
                }
            }

            Button("Add Run") {
                let totalDistance = Double(miles) + fractionMiles
                let newRun = Run(
                    goalName: goalName,
                    distanceInMiles: totalDistance,
                    pacePerMile: Time(hours: 0, minutes: 0, seconds: 0),
                    duration: Time(hours: hours, minutes: minutes, seconds: 0),
                    date: runDate
                )

                if Calendar.current.isDateInToday(runDate) {
                    mainViewModel.runArr.append(newRun)
                } else {
                    historyViewModel.addRun(newRun)
                }

                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
