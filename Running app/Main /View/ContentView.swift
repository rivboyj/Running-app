//
//  ContentView.swift
//  Running app
//
//  Created by River on 10/27/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    // Create a shared instance of HistoryViewModel if it's supposed to be shared across views.
    let historyViewModel = HistoryViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {
            GoalsView(viewModel: GoalViewModel(), historyViewModel: historyViewModel)
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
                .tag(0)
            
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(1)
            
            HistoryView(historyViewModel: historyViewModel)
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(2)
        }
    }
}
struct HomeView: View {
    // Assuming 'streak' is a state variable for demonstration purposes.
    // You would update this variable based on user input or app logic elsewhere.
    @State private var streak: Int = 0 // Replace with your own logic to determine the current streak.

    var body: some View {
        VStack {
            HStack {
                // Streak Counter in the top left inside a circle
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

            Spacer() 
        }
        .navigationBarTitle("Home", displayMode: .inline)
        .navigationBarItems(leading: HStack {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                Text("\(streak)")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}
