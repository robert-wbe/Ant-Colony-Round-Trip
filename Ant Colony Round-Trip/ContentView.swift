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
                    .disabled(editigPlaces)
            }
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
                                    .overlay {
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
                                searchPlace = ""
                            }) {
                                Image(systemName: "plus")
                                    .fontWeight(.light)
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
                    
                }.padding()
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

struct GlassSearchBar: View {
    @Binding var input: String
    var placeholder: String = ""
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(placeholder, text: $input)
                .textFieldStyle(.plain)
        }
        .fontWeight(.ultraLight)
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
