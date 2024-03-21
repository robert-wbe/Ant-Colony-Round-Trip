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
    static var divisionFactor: Double = 50000
    @Published var params = Params(alpha: 1, beta: 2, evaporationRate: 0.3, generationSize: 100)
    @Published var pheromoneMatrix: [[Double]] = []
    @Published var heuristicMatrix: [[Double]] = []
    @Published var runningACO: Bool = false
    @Published var iteration: Int = 0
    @Published var curTravelTime: Double = 0.0
    
    func initializeMatrices(numNodes: Int) {
        pheromoneMatrix = [[Double]](repeating: [Double](repeating: 1, count: numNodes), count: numNodes)
        heuristicMatrix = [[Double]](repeating: [Double](repeating: 1, count: numNodes), count: numNodes)
    }
    
    func getEdgeValue(_ startNode: Int, _ endNode: Int) -> Double {
        pow(pheromoneMatrix[startNode][endNode], params.alpha) * pow(heuristicMatrix[startNode][endNode], params.beta)
    }
    
    func getEdgeTime(_ startNode: Int, _ endNode: Int) -> Double {
        return AntColonyOptimizer.divisionFactor / heuristicMatrix[startNode][endNode]
    }
    
    func updateEdgePheromones(start: Int, end: Int, fitnessSum: Double) {
        pheromoneMatrix[start][end] = (1 - params.evaporationRate) * pheromoneMatrix[start][end] + params.evaporationRate * fitnessSum
    }
    
    func sigmoid(_ x: Double) -> Double {
        return 1 / (1 + exp(-x))
    }
    
    func terminateACO() {
        let numPlaces = self.pheromoneMatrix.count
        var visited = [Bool](repeating: false, count: numPlaces)
        let startPlace = 0
        var currentPlace = startPlace
        visited[currentPlace] = true
        var newPheromoneMatrix = [[Double]](repeating: [Double](repeating: 0, count: numPlaces), count: numPlaces)
        for _ in 0 ..< numPlaces - 1 {
            let nextPlace = (0 ..< numPlaces)
                .filter{!visited[$0]}
                .max(by: {
                    getEdgeValue(currentPlace, $0) < getEdgeValue(currentPlace, $1)
                })!
            newPheromoneMatrix[currentPlace][nextPlace] = 1
            newPheromoneMatrix[nextPlace][currentPlace] = 1
            visited[nextPlace] = true
            currentPlace = nextPlace
        }
        newPheromoneMatrix[startPlace][currentPlace] = 1
        newPheromoneMatrix[currentPlace][startPlace] = 1
        pheromoneMatrix = newPheromoneMatrix
    }
    
    func startACO() {
        runningACO = true
        iteration = 0
        curTravelTime = 0.0
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if !self.runningACO {
                timer.invalidate()
                self.terminateACO()
                return
            }
            self.iteration += 1
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
                for _ in 1..<numPlaces {
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
                var pathFitness = self.getEdgeTime(antPath[0], antPath[numPlaces - 1])
                for i in 1 ..< numPlaces {
                    pathFitness += self.getEdgeTime(antPath[i], antPath[i - 1])
                }
                self.curTravelTime = pathFitness
                pathFitness = AntColonyOptimizer.divisionFactor / pathFitness
                newPheromones[antPath[0]][antPath[numPlaces - 1]] += pathFitness
                newPheromones[antPath[numPlaces - 1]][antPath[0]] += pathFitness
                for i in 1 ..< numPlaces {
                    newPheromones[antPath[i - 1]][antPath[i]] += pathFitness
                    newPheromones[antPath[i]][antPath[i - 1]] += pathFitness
                }
            }
            
            var pheromoneMax: Double = 0.0
            for i in 0 ..< numPlaces {
                for j in 0 ..< numPlaces {
                    pheromoneMax = max(pheromoneMax, newPheromones[i][j]) + 0.01
                }
            }
            
            for i in 0 ..< numPlaces {
                for j in 0 ..< numPlaces {
                    self.updateEdgePheromones(start: i, end: j, fitnessSum: newPheromones[i][j] / pheromoneMax)
                }
            }
        }
    }
}
