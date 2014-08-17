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
        // var openList: [Node] = [startNode]
        var openList = IndexedArray(extractIndex: { (node: Node) -> Double in
            return node.fValue
        })
        openList.add(startNode)
        
        var openSet = Set<Node>()
        var closedList = Set<Node>()
        
        // Pre-calculate the h value of every node
        map.precalculateHValue(endNode)
        
        // Add the neighbours of the start node to the open list to start the iteration process
        while let currentNode = openList.array.first {
            openSet.remove(currentNode)
            openList.removeAtIndex(0)
            closedList.insert(currentNode)
            
            // Check if we reached the end node
            if currentNode == endNode {
                return backtracePath(endNode)
            }
            
            // Returns the neighbours of the node
            var validMoves = map.validMoves(currentNode)
            
            // Check each neighbour and add it to the open list
            for neighbour in validMoves {
                // We don't check the node if it's in the closed list
                if closedList.contains(neighbour) { continue }
                // If we can't access the tile we have to skip it
                if !neighbour.accessible { continue }
                // Calculate the move cost
                let moveCost = map.moveCostForNode(currentNode, toNode: neighbour)
                
                if openSet.contains(neighbour) {
                    // The node was already added to the open list
                    // We need to check if we have to re-parent it
                    //                    if neighbour.gValue > currentNode.gValue + moveCost {
                    //                        neighbour.parent = currentNode
                    //                        neighbour.gValue = currentNode.gValue + moveCost
                    //                    }
                } else {
                    // Set the parent of the node
                    neighbour.parent = currentNode
                    
                    // Calculate the g value
                    // TODO: Re-implement the move cost
                    neighbour.gValue = currentNode.gValue// + moveCost
                    
                    // Add the new node to the open list
                    openSet.insert(neighbour)
                    openList.add(neighbour)
                }
            }
        }
        
        // If there is no route, we just return an empty array
        return []
    }

}
