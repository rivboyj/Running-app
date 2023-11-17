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
            
            HomeView(mainViewModel: mainViewModel)
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

struct HomeView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @State private var streak: Int = 0

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

                NavigationLink(destination: AddRunView(mainViewModel: mainViewModel)) {
                    Text("Add a Run")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                List {
                    Section(header: Text("Today's Runs")) {
                        ForEach(mainViewModel.runArr.filter { Calendar.current.isDateInToday($0.date) }) { run in
                            HStack {
                                Text(run.goalName)
                                Spacer()
                                Button(action: {
                                    if let index = mainViewModel.runArr.firstIndex(of: run) {
                                        mainViewModel.runArr.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "xmark.circle")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}


struct AddRunView: View {
    @ObservedObject var mainViewModel: MainViewModel
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
                                Text("\(hour) hr")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 150)
                        .clipped()

                        Picker("Minutes", selection: $minutes) {
                            ForEach(0..<60, id: \.self) { minute in
                                Text("\(minute) min")
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
                                Text("\(mile) mi")
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 100, height: 150)
                        .clipped()

                        Picker("Fraction", selection: $fractionMiles) {
                            ForEach(Array(stride(from: 0.0, to: 1.0, by: 0.1)), id: \.self) { frac in
                                Text("\(frac, specifier: "%.1f") mi")
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
                mainViewModel.runArr.append(newRun)
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
