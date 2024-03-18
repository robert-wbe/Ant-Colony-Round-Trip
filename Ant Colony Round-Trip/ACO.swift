//
//  ACO.swift
//  Ant Colony Round-Trip
//
//  Created by Robert Wiebe on 3/17/24.
//

import Foundation

class AntColonyOptimizer: ObservableObject {
    struct Params {
        var alpha: Double
        var beta: Double
        var evaporationRate: Double
    }
    
    @Published var params = Params(alpha: 1, beta: 1, evaporationRate: 0.5)
    @Published var pheromoneMatrix: [[Double]] = []
    @Published var heuristicMatrix: [[Double]] = []
    
    func initializePheromones(numNodes: Int) {
        pheromoneMatrix = [[Double]](repeating: [Double](repeating: 1, count: numNodes), count: numNodes)
    }
    
    func startACO() {
        
    }
}
