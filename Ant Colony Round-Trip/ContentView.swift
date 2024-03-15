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
    @State var editigPlaces: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Map() {
                ForEach(routes, id: \.self) { route in
                    MapPolyline(route)
                        .stroke(.orange, lineWidth: 5)
                        .stroke(.shadow(.drop(color: .orange, radius: 5)))
                }
                ForEach(Array(places.enumerated()), id: \.offset) { idx, place in
                    Annotation(place.name ?? "No name", coordinate: place.placemark.coordinate) {
                        if editigPlaces {
                            Circle()
                                .frame(width: 20)
                                .foregroundStyle(.red.gradient)
                                .overlay(alignment: .center) {
                                    Image(systemName: "minus")
                                }
                                .onTapGesture {
                                    places.remove(at: idx)
                                }
                        } else {
                            Circle()
                                .foregroundStyle(.blue.gradient)
                        }
                    }
                }
            }
            
            HStack {
                GlassSearchBar(input: $searchPlace, placeholder: "Search cities")
                    .overlay(alignment: .trailing) {
                        Button(action: {
                            addPlace()
                        }) {
                            Image(systemName: "plus")
                                .fontWeight(.regular)
                                .padding(3)
                        }
                        .buttonStyle(.plain)
                        .aspectRatio(1, contentMode: .fit)
                        .background(.blue.gradient)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(color: .blue.opacity(0.4), radius: 3)
                        .padding(.trailing, 6.8)
                        .disabled(searchPlace.isEmpty)
                    }
                    .font(.system(size: 20))
                    .frame(width: 250)
                    
                Spacer()
                Button(action: {
                    editigPlaces.toggle()
                    if editigPlaces {
                        routeMatrix.removeAll()
                        routes.removeAll()
                    }
                }) {
                    Label("Edit cities", systemImage: "checklist")
                        .padding(6)
                        .background(.indigo, in: RoundedRectangle(cornerRadius: 7.5))
                }.buttonStyle(.plain)
                    .disabled(places.isEmpty)
                Button(action: {
                    constructRouteMatrix()
                    // TODO: ACO alogrithm
                }) {
                    Label("Run ACO", systemImage: "ant")
                        .padding(6)
                        .background(.brown, in: RoundedRectangle(cornerRadius: 7.5))
                }.buttonStyle(.plain)
                    .disabled(editigPlaces || places.count <= 1)
            }.padding()
        }
    }
    
    /// Get the best match for user-inputted search string from the MapKit API, add it to `places`.
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
        searchPlace = ""
    }
    
    /// Fetch routes between all pairs of places asynchronously and in parallel. Add them to the `routeMatxix`.
    func constructRouteMatrix() {
        let numPlaces = places.count
        
        Task {
            try await withThrowingTaskGroup(of: (Int, Int, MKRoute?).self) { group in
                for source in 0 ..< numPlaces {
                    for destination in source+1 ..< numPlaces {
                        group.addTask {
                            let request = MKDirections.Request()
                            request.source = places[source]
                            request.destination = places[destination]
                            let directions = MKDirections(request: request)
                            let response = try? await directions.calculate()
                            return (source, destination, response?.routes.first)
                        }
                    }
                }
                routeMatrix = [[MKRoute]](repeating: [MKRoute](repeating: .init(), count: numPlaces), count: numPlaces)
                
                for try await (src, dst, route) in group {
                    if let route = route {
                        routeMatrix[src][dst] = route
                        routeMatrix[dst][src] = route
                        routes.append(route)
                    }
                }
            }
        }
    }
}

/// A glossy, translucent search bar
struct GlassSearchBar: View {
    @Binding var input: String
    var placeholder: String = ""
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(placeholder, text: $input)
                .textFieldStyle(.plain)
        }
        .fontWeight(.light)
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.thinMaterial)
                .stroke(.gray)
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
