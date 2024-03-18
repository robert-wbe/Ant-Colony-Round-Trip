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
    
    func initializeMatrices(numNodes: Int) {
        pheromoneMatrix = [[Double]](repeating: [Double](repeating: 0.1, count: numNodes), count: numNodes)
        heuristicMatrix = [[Double]](repeating: [Double](repeating: 1, count: numNodes), count: numNodes)
    }
    
    func getEdgeValue(_ startNode: Int, _ endNode: Int) -> Double {
        pow(pheromoneMatrix[startNode][endNode], params.alpha) * pow(heuristicMatrix[startNode][endNode], params.beta)
    }
    
    func updateEdgePheromones(start: Int, end: Int, fitnessSum: Double) {
        pheromoneMatrix[start][end] = min(100, (1 - params.evaporationRate) * pheromoneMatrix[start][end] + params.evaporationRate * fitnessSum)
    }
    
    func startACO() {
        runningACO = true
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if !self.runningACO {
                timer.invalidate()
            }
            let numPlaces = self.pheromoneMatrix.count
            var visited = [Bool](repeating: false, count: numPlaces)
            var paths: [[Int]] = []
            for _ in 0..<self.params.generationSize {
                // individual ant
                // setup visited set
                for i in 1..<numPlaces { visited[i] = false }
                var currentNode = 0
                visited[0] = true
                var antPath = [0]
                
                // walk through graph
                for nodesVisited in 1..<numPlaces {
                    let unvisitedNodes = Array((0..<numPlaces).filter{!visited[$0]})
                    let valueSum = unvisitedNodes.reduce(0.0){partialSum, node in partialSum + self.getEdgeValue(currentNode, node)}
                    let randomNumber = Double.random(in: 0...1)
                    var accumulatedValue = 0.0
                    for node in unvisitedNodes {
                        accumulatedValue += self.getEdgeValue(currentNode, node) / valueSum
                        if accumulatedValue >= randomNumber {
                            antPath.append(node)
                            currentNode = node
                            visited[node] = true
                            break
                        }
                    }
                }
                
                paths.append(antPath)
            }
            
            var newPheromones: [[Double]] = .init(repeating: .init(repeating: 0, count: numPlaces), count: numPlaces)
            for antPath in paths {
                var pathFitness = self.getEdgeValue(antPath[0], antPath[numPlaces - 1])
                for i in 1 ..< numPlaces {
                    pathFitness += self.getEdgeValue(antPath[i], antPath[i-1])
                }
                newPheromones[0][numPlaces - 1] += pathFitness
                newPheromones[numPlaces - 1][0] += pathFitness
                for i in 1 ..< numPlaces {
                    newPheromones[i - 1][i] += pathFitness
                    newPheromones[i][i - 1] += pathFitness
                }
            }
            
            for i in 0 ..< numPlaces {
                for j in 0 ..< numPlaces {
                    self.updateEdgePheromones(start: i, end: j, fitnessSum: newPheromones[i][j])
                }
            }
        }
    }
}
