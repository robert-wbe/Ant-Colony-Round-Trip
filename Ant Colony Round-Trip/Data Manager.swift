//
//  Data Manager.swift
//  Ant Colony Round-Trip
//
//  Created by Robert Wiebe on 3/24/24.
//

import Foundation
import SwiftUI
import MapKit

class DataManager: ObservableObject {
    static let maxCalls = 50
    static let waitTime: UInt64 = 60
    var callsDone: Int = 0
    @Published var pendingCalls = 0
    var resumeTime: Date? = nil
    @Published var routeCounter: Int = 0
    @Published var waitingForAPI: Bool = false
    
    func fetchRoutes(places: [MKMapItem]) async throws -> [[MKRoute?]] {
        let numPlaces: Int = places.count
        return try await withThrowingTaskGroup(of: (Int, Int, MKRoute?).self) { group in
            var routeMatrix = [[MKRoute?]](repeating: [MKRoute?](repeating: nil, count: numPlaces), count: numPlaces)
            
            for source in 0 ..< numPlaces {
                for destination in source+1 ..< numPlaces {
                    group.addTask {
                        let route = try await self.fetchRoute(source: places[source], dest: places[destination])
                        return (source, destination, route)
                    }
                }
            }
            
            for try await (src, dst, route) in group {
                if let route = route {
                    routeMatrix[src][dst] = route
                    routeMatrix[dst][src] = route
                }
            }
            
            DispatchQueue.main.async {
                self.routeCounter = 0
            }
            return routeMatrix
        }
    }
    
    func fetchRoute(source: MKMapItem, dest: MKMapItem) async throws -> MKRoute? {
        try await self.getDownloadPermission()
        
        let request = MKDirections.Request()
        request.source = source
        request.destination = dest
        let directions = MKDirections(request: request)
        
        self.callsDone += 1
        DispatchQueue.main.async {
            self.pendingCalls += 1
        }
        let response = try? await directions.calculate()
        
        DispatchQueue.main.async {
            self.pendingCalls -= 1
            self.routeCounter += 1
        }
        
        return response?.routes.first
    }
    
    func fetchPlace(searchKeyword: String, at region: MKCoordinateRegion) async throws -> MKMapItem? {
        try await self.getDownloadPermission()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchKeyword
        request.region = region
        
        self.callsDone += 1
        let results = try? await MKLocalSearch(request: request).start()
        let bestResult = results?.mapItems[0]
        return bestResult
    }
    
    func getDownloadPermission() async throws {
        while let resumeTime = self.resumeTime {
            if Date.now >= resumeTime {
                DispatchQueue.main.async {
                    self.waitingForAPI = false
                }
                self.resumeTime = nil
            } else {
                try await Task.sleep(nanoseconds: (Self.waitTime + 2) * 1000000000)
            }
        }
        
        if self.callsDone == Self.maxCalls - 1 {
            self.resumeTime = Date.now + TimeInterval(Self.waitTime)
            DispatchQueue.main.async {
                self.waitingForAPI = true
            }
            self.callsDone = 0
        }
    }
}
