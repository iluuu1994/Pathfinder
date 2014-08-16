//
//  AStarAlgorithm.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 16/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public class AStarAlgorithm: Algorithm {

    public class func findPathInMap(map: Map, startNode: Node, endNode: Node) -> [Node] {
        var openList: [Node] = [startNode]
        var closedList: [Node] = []
        
        // Pre-calculate the h value of every node
        map.precalculateHValue(endNode)
        
        // Add the neighbours of the start node to the open list to start the iteration process
        var iterations = 0
        while let currentNode = openList.first {
            iterations++
            openList.removeAtIndex(0)
            closedList.append(currentNode)
            
            // Check if we reached the end node
            if currentNode == endNode {
                println("Iterations: \(iterations)")
                println("Open List Count: \(countElements(openList))")
                println("Closed List Count: \(countElements(closedList))")
                for node in closedList {
                    println(node.hValue)
                }
                
                var route = [endNode]
                while let parent = route.first?.parent {
                    route.insert(parent, atIndex: 0)
                }
                
                return route
            }
            
            // Returns the neighbours of the node
            let validMoves = map.validMoves(currentNode)
            
            // Check each neighbour and add it to the open list
            for neighbour in validMoves {
                // We don't check the node if it's in the closed list
                if contains(closedList, neighbour) { continue }
                // If we can't access the tile we have to skip it
                if !neighbour.accessible { continue }
                
                if contains(openList, neighbour) {
                    // The node was already added to the open list
                    // We need to check if we have to re-parent it
                    if neighbour.gValue > currentNode.gValue + map.moveCostForNode(currentNode, toNode: neighbour) {
                        neighbour.parent = currentNode
                        neighbour.gValue = currentNode.gValue + map.moveCostForNode(currentNode, toNode: neighbour)
                    }
                } else {
                    // Set the parent of the node
                    neighbour.parent = currentNode
                    
                    // Calculate the g value
                    neighbour.gValue = currentNode.gValue// + map.moveCostForNode(currentNode, toNode: neighbour)
                    
                    // Add the new node to the open list
                    openList.append(neighbour)
                }
            }
            
            // Sort to keep looking for the best path
            openList.sort { $0.fValue < $1.fValue }
        }
        
        // If there is no route, we just return an empty array
        return closedList
    }

}
