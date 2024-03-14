//
//  ContentView.swift
//  Ant Colony Round-Trip
//
//  Created by Robert Wiebe on 3/4/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var routeMatrix: [[MKRoute]] = []
    @State var routes: [MKRoute] = []
    @State var places: [MKMapItem] = []
    @State var searchPlace: String = ""
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search cities", text: $searchPlace)
                Button("Add place") {
                    addPlace()
                    searchPlace = ""
                }.buttonStyle(.borderedProminent)
                Button("Make route matrix") {
                    constructRouteMatrix()
                }.buttonStyle(.borderedProminent)
            }
            Map() {
                ForEach(routes, id: \.self) { route in
                    MapPolyline(route)
                        .stroke(.orange, lineWidth: 5)
                        .stroke(.shadow(.drop(color: .orange, radius: 5)))
                }
                ForEach(places, id: \.self) { place in
                    Annotation(place.name ?? "No name", coordinate: place.placemark.coordinate) {
                        Circle()
                            .foregroundStyle(.red.gradient)
                    }
                }
            }
        }.padding()
    }
    
    func addPlace() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchPlace
        Task {
            let results = try? await MKLocalSearch(request: request).start()
            let bestResult = results?.mapItems[0]
            if let bestResult = bestResult{
                places.append(bestResult)
            }
        }
    }
    
    func addRoute(from source: Int, to destination: Int) {
        let request = MKDirections.Request()
        request.source = places[source]
        request.destination = places[destination]
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            if let route = response?.routes.first {
                routes.append(route)
                routeMatrix[source][destination] = route
                routeMatrix[destination][source] = route
            }
        }
    }
    
    func constructRouteMatrix() {
        let numPlaces = places.count
        routeMatrix = [[MKRoute]](repeating: [MKRoute](repeating: .init(), count: numPlaces), count: numPlaces)
        for i in 0 ..< numPlaces {
            for j in i+1 ..< numPlaces {
                addRoute(from: i, to: j)
            }
        }
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
