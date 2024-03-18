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
        var generationSize: Int
    }
    
    @Published var params = Params(alpha: 1, beta: 1, evaporationRate: 0.5, generationSize: 50)
    @Published var pheromoneMatrix: [[Double]] = []
    @Published var heuristicMatrix: [[Double]] = []
    @Published var runningACO: Bool = false
    
    func initializePheromones(numNodes: Int) {
        pheromoneMatrix = [[Double]](repeating: [Double](repeating: 1, count: numNodes), count: numNodes)
    }
    
    func startACO() {
        
    }
}
