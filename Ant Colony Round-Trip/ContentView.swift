//
//  ContentView.swift
//  Ant Colony Round-Trip
//
//  Created by Robert Wiebe on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, teammates (especially Omar)!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

/*
 Search for cities
 Add for cities
 Calculate routes between cities
 Add routes to Edge matrix
 Run ACO on edge matrix
 Visualize Pheromone values
 */
