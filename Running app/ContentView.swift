//
//  ContentView.swift
//  Running app
//
//  Created by River on 10/27/23.
//

import SwiftUI


struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            FirstView()
                .tabItem {
                    Label("Goals", systemImage: "globe")
                }
                .tag(0)
            
            SecondView()
                .tabItem {
                    Label("History", systemImage: "star")
                }
                .tag(1)
        }
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
