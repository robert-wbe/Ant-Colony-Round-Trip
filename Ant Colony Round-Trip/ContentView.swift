//
//  ContentView.swift
//  Ant Colony Round-Trip
//
//  Created by Robert Wiebe on 3/4/24.
//

import SwiftUI
import MapKit



struct ContentView: View {
    @State var routeMatrix: [[MKRoute?]] = []
    @ObservedObject var aco = AntColonyOptimizer()
    
    @State var places: [MKMapItem] = []
    @State var searchPlace: String = ""
    @State var editigPlaces: Bool = false
    @State var settingsSheetPresenetd: Bool = false
    
    @State var fetchingRoutes: Bool = false
    @State var routesCalculated: Int = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            Map() {
                ForEach(Array(routeMatrix.enumerated()), id: \.offset) { i, row in
                    ForEach(Array(row.enumerated()), id: \.offset) { j, route in
                        if let route = route {
                            let pheromone = aco.pheromoneMatrix[i][j]
                            MapPolyline(route)
                                .stroke(.orange.opacity(pheromone), lineWidth: 5)
                        }
                    }
                }
                ForEach(Array(places.enumerated()), id: \.offset) { idx, place in
                    if editigPlaces {
                        Annotation(place.name ?? "No name", coordinate: place.placemark.coordinate) {
                            Circle()
                                .frame(width: 20)
                                .foregroundStyle(.red.gradient)
                                .overlay(alignment: .center) {
                                    Image(systemName: "minus")
                                }
                                .onTapGesture {
                                    places.remove(at: idx)
                                    if (places.isEmpty) {
                                        editigPlaces = false
                                    }
                                }
                        }
                    } else {
                        Marker(place.name ?? "Unnamed place", systemImage: "mappin", coordinate: place.placemark.coordinate
                        ).tint(.blue)
                    }
                }
            }.overlay {
                if fetchingRoutes {
                    progressView
                }
            }
            
            toolbar
        }
    }
    
    var toolbar: some View {
        HStack {
            ZStack(alignment: .trailing) {
                GlassSearchBar(input: $searchPlace, placeholder: "Search cities")
                    .font(.system(size: 20))
                    .onKeyPress(.return) {
                        addPlace()
                        return .handled
                    }
                Button(action: {
                    addPlace()
                }) {
                    Label("Add", systemImage: "plus")
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .padding(3)
                        .shadow(radius: 10)
                }
                .buttonStyle(.plain)
                .background(.blue.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(color: .blue.opacity(0.4), radius: 3)
                .padding(6.8)
                .disabled(searchPlace.isEmpty)
            }
            
            .frame(width: 250)
                
            Spacer()
            Button(action: {
                editigPlaces.toggle()
                if editigPlaces {
                    routeMatrix.removeAll()
                }
            }) {
                Label("Edit cities", systemImage: "checklist")
                    .padding(6)
                    .background(.indigo, in: RoundedRectangle(cornerRadius: 7.5))
            }.buttonStyle(.plain)
                .disabled(places.isEmpty)
            HStack {
                Button(action: {
                    if aco.runningACO {
                        aco.runningACO = false
                    } else {
                        constructRouteMatrix()
                    }
                }) { aco.runningACO ? Label("Stop ACO", systemImage: "xmark") : Label("Run ACO", systemImage: "ant") }
                .buttonStyle(.plain)
                .disabled(editigPlaces || places.count <= 1)
                Divider().frame(height: 15)
                Button(action: {
                    settingsSheetPresenetd = true
                }) { Image(systemName: "gearshape").font(.body) }
                .buttonStyle(.plain)
                .sheet(isPresented: $settingsSheetPresenetd) {
                    ACOParamsEditor(acoParams: $aco.params, isPresented: $settingsSheetPresenetd)
                        .frame(width: 600)
                }
            }
            .padding(5)
            .background(.brown, in: RoundedRectangle(cornerRadius: 7.5))
        }.padding()
    }
    
    var progressView: some View {
        let routesCount = places.count * (places.count-1) / 2
        return ProgressView(value: Double(routesCalculated), total: Double(routesCount),
                label: {
                    Text("Calculating routes...")
                        .padding(.bottom, 4)
                }, currentValueLabel: {
                    let formatted = (Double(routesCalculated) / Double(routesCount)).formatted(.percent.precision(.fractionLength(0...2)))
                    Text("\(formatted)")
                        .padding(.top, 4)
                }
        )
        .progressViewStyle(.circular)
        .padding()
        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 20))
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
                            request.source = await places[source]
                            request.destination = await places[destination]
                            let directions = MKDirections(request: request)
                            let response = try? await directions.calculate()
                            return (source, destination, response?.routes.first)
                        }
                    }
                }
                routeMatrix = [[MKRoute?]](repeating: [MKRoute?](repeating: nil, count: numPlaces), count: numPlaces)
                aco.initializeMatrices(numNodes: numPlaces)
                
                routesCalculated = 0
                fetchingRoutes = true
                for try await (src, dst, route) in group {
                    if let route = route {
                        routeMatrix[src][dst] = route
                        routeMatrix[dst][src] = route
                        aco.heuristicMatrix[src][dst] = 10000 / route.expectedTravelTime
                        aco.heuristicMatrix[dst][src] = 10000 / route.expectedTravelTime
                    }
                    routesCalculated += 1
                }
                fetchingRoutes = false
                aco.startACO()
            }
            
        }
        
        
    }
    
    func runACO() {
        
    }
}

struct ACOParamsEditor: View {
    @Binding var acoParams: AntColonyOptimizer.Params
    @Binding var isPresented: Bool
    
    var body: some View {
        Form {
            Section("Ant parameters (pheromone weighting vs. heuristic weighting)") {
                Slider(value: $acoParams.alpha, in: 0...2, step: 0.05, label: {
                    Text("α (pheromone) = \(acoParams.alpha, specifier: "%.2f")")
                        .frame(width: 150, alignment: .trailing)
                }, minimumValueLabel: {
                    Text("0.0")
                }, maximumValueLabel: {
                    Text("2.0")
                })
                Slider(value: $acoParams.beta, in: 0...2, step: 0.05, label: {
                    Text("β (heuristic) = \(acoParams.beta, specifier: "%.2f")")
                        .frame(width: 150, alignment: .trailing)
                }, minimumValueLabel: {
                    Text("0.0")
                }, maximumValueLabel: {
                    Text("2.0")
                })
            }
            Divider()
            Section("Evaporation rate") {
                HStack(alignment: .top, spacing: 0) {
                    Text("ρ = \(acoParams.evaporationRate, specifier: "%.2f")")
                    VStack {
                        Slider(value: $acoParams.evaporationRate, in: 0...1, step: 0.05, label: {}, minimumValueLabel: {
                            Text("0.0")
                        }, maximumValueLabel: {
                            Text("1.0")
                        })
                        HStack(spacing: 3) {
                            Text("Pushes toward")
                            Text("Exploitation").fontWeight(.bold).foregroundStyle(.orange)
                            Spacer()
                            Text("Pushes toward")
                            Text("Exploration").fontWeight(.bold).foregroundStyle(.cyan)
                        }.padding(.leading, 8)
                    }
                }
            }
            HStack {
                Spacer()
                Button("Done") {
                    isPresented = false
                }.buttonStyle(.borderedProminent)
            }
        }.padding()
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

#Preview {
    ACOParamsEditor(acoParams: .constant(.init(alpha: 1, beta: 1, evaporationRate: 1, generationSize: 50)), isPresented: .constant(true))
        .frame(width: 600)
}

/*
 Search for cities
 Add for cities
 Calculate routes between cities
 Add routes to Edge matrix
 Run ACO on edge matrix
 Visualize Pheromone values
 */
