//
//  AStarAlgorithm.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 16/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

/// AStarAlgorithm is a class that implements the A* Algorithm for pathfinding
/// http://en.wikipedia.org/wiki/A*_search_algorithm
public class AStarAlgorithm: Algorithm {

    /// Finds the path from point A to B in any Map
    public class func findPathInMap(map: Map, startNode: Node, endNode: Node) -> [Node] {
        // var openList: [Node] = [startNode]
        var openList = IndexedArray<Node, Double>(extractIndex: { (node) in return node.fValue })
        openList.add(startNode)
        
        // Pre-calculate the h value of every node
        map.precalculateHValue(endNode)
        
        // Add the neighbours of the start node to the open list to start the iteration process
        while let currentNode = openList.array.first {
            currentNode.closed = true
            openList.removeAtIndex(0)
            
            // Check if we reached the end node
            if currentNode == endNode {
                return backtracePath(endNode)
            }
            
            // Returns the neighbours of the node
            var validMoves = map.validMoves(currentNode)
            
            // Check each neighbour and add it to the open list
            for neighbour in validMoves {
                // We don't check the node if it's in the closed list
                if neighbour.closed { continue }
                // If we can't access the tile we have to skip it
                if !neighbour.accessible { continue }
                // Calculate the move cost
                let moveCost = map.moveCostForNode(currentNode, toNode: neighbour)
                
                if neighbour.opened {
                    // The node was already added to the open list
                    // We need to check if we have to re-parent it
                    if neighbour.gValue > currentNode.gValue + moveCost {
                        neighbour.parent = currentNode
                        neighbour.gValue = currentNode.gValue + moveCost
                    }
                } else {
                    // Set the parent of the node
                    neighbour.parent = currentNode
                    
                    // Calculate the g value
                    neighbour.gValue = currentNode.gValue + moveCost
                    
                    // Add the new node to the open list
                    neighbour.opened = true
                    openList.add(neighbour)
                }
            }
        }
        
        // If there is no route, we just return an empty array
        return []
    }

}
