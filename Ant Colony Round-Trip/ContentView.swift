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
    @StateObject var aco = AntColonyOptimizer()
    @StateObject var dataManager = DataManager()
    @State var visibleRegion: MKCoordinateRegion = .init(center: .init(latitude: 38.88, longitude: 99.33), latitudinalMeters: 1_000_000, longitudinalMeters: 1_000_000)
    
    @State var places: [MKMapItem] = []
    @State var searchPlace: String = ""
    @State var editigPlaces: Bool = false
    @State var settingsSheetPresenetd: Bool = false
    
    @State var fetchingRoutes: Bool = false
    @State var modifiedPlaces: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Map() {
                ForEach(Array(routeMatrix.enumerated()), id: \.offset) { i, row in
                    ForEach(Array(row.enumerated()), id: \.offset) { j, route in
                        if let route = route {
                            let pheromone = aco.pheromoneMatrix[i][j] / aco.pheromoneMax
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
                                    self.modifiedPlaces = true
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
            .onMapCameraChange { context in
                self.visibleRegion = context.region
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
            HStack {
                Button(action: {
                    editigPlaces.toggle()
                    if editigPlaces {
                        routeMatrix.removeAll()
                    }
                }) {
                    Label("Edit cities", systemImage: "checklist")
                        
                }
                .buttonStyle(.plain)
                .disabled(places.isEmpty || aco.runningACO)
                .overlay {
                    if editigPlaces {
                        Button("Delete All") {
                            places.removeAll()
                            editigPlaces = false
                        }
                        .offset(y: 30)
                        .buttonStyle(.borderedProminent)
                    }
                }
                Divider().frame(height: 15)
                Menu(content: {
                    Section("Presets") {
                        ForEach(PresetPlaceGroups) {group in
                            Button(group.name) {
                                self.routeMatrix = []
                                self.places = group.places
                                self.modifiedPlaces = true
                            }
                        }
                    }
                }, label: {
                    Image(systemName: "list.star")
                }).menuStyle(.borderlessButton)
                    .frame(width: 32)
            }
            .padding(6)
            .background(.indigo, in: RoundedRectangle(cornerRadius: 7.5))
            HStack {
                Button(action: {
                    if aco.runningACO {
                        aco.runningACO = false
                    } else {
                        startACO()
                    }
                }) { aco.runningACO ? Label("Stop ACO", systemImage: "xmark") : Label("Run ACO", systemImage: "ant") }
                .buttonStyle(.plain)
                .disabled(editigPlaces || places.count <= 2)
                Divider().frame(height: 15)
                Button(action: {
                    settingsSheetPresenetd = true
                }) { Image(systemName: "gearshape").font(.body) }
                .buttonStyle(.plain)
                .disabled(aco.runningACO)
                .sheet(isPresented: $settingsSheetPresenetd) {
                    ACOParamsEditor(acoParams: $aco.params, isPresented: $settingsSheetPresenetd)
                        .frame(width: 600)
                }
            }
            .padding(5)
            .background(.brown, in: RoundedRectangle(cornerRadius: 7.5))
            .overlay {
                if aco.runningACO {
                    acoInfoView
                        .offset(x: -14, y: 45)
                }
            }
        }.padding()
    }
    
    var acoInfoView: some View {
        VStack(alignment: .leading) {
            Label("Iteration: \(aco.iteration)", systemImage: "number")
            Label("Travel time: \(formatTimeInterval(aco.curTravelTime))", systemImage: "timer")
        }.frame(width: 140)
        .padding(5)
        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 5))
    }
    
    var progressView: some View {
        let routesCount = places.count * (places.count-1) / 2
        let routesFetched = dataManager.routeCounter
        return ProgressView(value: Double(routesFetched), total: Double(routesCount),
                label: {
                    Text("Calculating routes...")
                        .padding(.bottom, 4)
                }, currentValueLabel: {
                    let percentage = (Double(routesFetched) / Double(routesCount)).formatted(.percent.precision(.fractionLength(0...2)))
                    VStack {
                        if dataManager.waitingForAPI && dataManager.pendingCalls == 0 {
                            VStack {
                                Label("API limit reached", systemImage: "exclamationmark.triangle.fill")
                                    .symbolRenderingMode(.multicolor)
                                Text("Waiting 60 seconds\nto continue...")
                                    .multilineTextAlignment(.center)
                                    .italic()
                            }
                        }
                        Text("\(percentage)").fontWeight(.semibold)
                        Text("\(routesFetched)/\(routesCount)")
                    }.padding(.top, 4)
                }
        )
        .progressViewStyle(.circular)
        .padding()
        .background(.thickMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
    
    /// Get the best match for user-inputted search string from the MapKit API, add it to `places`.
    func addPlace() {
        self.modifiedPlaces = true
        Task {
            let placeResult = try await dataManager.fetchPlace(searchKeyword: searchPlace, at: visibleRegion)
            if let place = placeResult {
                places.append(place)
                searchPlace = ""
            }
        }
    }
    
    /// Fetch routes between all pairs of places asynchronously and in parallel. Add them to the `routeMatxix`.
    func startACO() {
        let numPlaces = places.count
        
        Task {
            
            aco.initializeMatrices(numNodes: numPlaces)
            if modifiedPlaces {
                self.fetchingRoutes = true
                self.routeMatrix = try await dataManager.fetchRoutes(places: self.places)
                self.fetchingRoutes = false
            }
            
            // Setting the heuristic values based on the calculated routes' expected travel times
            for i in 0 ..< numPlaces {
                for j in 0 ..< numPlaces {
                    if let route = routeMatrix[i][j] {
                        aco.heuristicMatrix[i][j] = AntColonyOptimizer.divisionFactor / route.expectedTravelTime
                    }
                }
            }
            
            self.modifiedPlaces = false
            aco.startACO()
        }
        
        
    }
    
    func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        
        return String(format: "%02d:%02d", hours, minutes)
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
                Slider(value: $acoParams.beta, in: 0...3, step: 0.05, label: {
                    Text("β (heuristic) = \(acoParams.beta, specifier: "%.2f")")
                        .frame(width: 150, alignment: .trailing)
                }, minimumValueLabel: {
                    Text("0.0")
                }, maximumValueLabel: {
                    Text("3.0")
                })
            }
            Divider()
            Section("Generation size") {
                HStack {
                    
                    TextField("Gen size", text: .init(get: {
                        acoParams.generationSize.description
                    }, set: {
                        acoParams.generationSize = Int($0) ?? 50
                    })).frame(width: 100)
                        .textFieldStyle(.roundedBorder)
                    Stepper("", value: $acoParams.generationSize, in: 10...100)
                }
                .offset(x: 27)
                .padding(.bottom, 5)
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
    ACOParamsEditor(acoParams: .constant(.init(alpha: 1, beta: 2, evaporationRate: 0.3, generationSize: 50)), isPresented: .constant(true))
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
