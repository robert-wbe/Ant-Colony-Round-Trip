//
//  ContentView.swift
//  Ant Colony Round-Trip
//
//  Created by Robert Wiebe on 3/4/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var places: [CLLocation] = [CLLocation(latitude: 36.8127, longitude: -119.7466)]
    @State var searchString: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search cities", text: $searchString)
                Button("Add place") {
                    // put action here
                }
            }
            Map() {
                Annotation("Fresno State", coordinate: places[0].coordinate) {
                    Circle()
                }
            }
        }.padding()
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
