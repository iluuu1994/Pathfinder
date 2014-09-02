//
//  AStarAlgorithm.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 16/08/14.
//  Copyright (c) 2014 Ilija Tovilo
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

/// AStarAlgorithm is a class that implements the A* Algorithm for pathfinding
/// http://en.wikipedia.org/wiki/A*_search_algorithm
@objc(PFAStarAlgorithm)
public class AStarAlgorithm: Algorithm {

    /// Finds the path from point A to B in any Map
    @objc
    public class func findPathInMap(map: Map, startNode: Node, endNode: Node) -> [Node] {
        // var openList: [Node] = [startNode]
        var openList = IndexedArray<Node, Int>(extractIndex: { (node) in return node.fValue })
        openList.add(startNode)
        
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
                // If we can't access the tile we have to skip it
                if !neighbour.accessible { continue }
                // Calculate the move cost
                let moveCost = map.moveCostForNode(currentNode, toNode: neighbour)
                // We don't check the node if it's in the closed list
                if neighbour.closed && (currentNode.gValue + moveCost) >= neighbour.gValue {
                    continue
                }
                
                if neighbour.opened {
                    // The node was already added to the open list
                    // We need to check if we have to re-parent it
                    neighbour.parent = currentNode
                    neighbour.gValue = currentNode.gValue + moveCost
                    
                    if !neighbour.closed {
                        // Re-add it the the open list so it's sorted
                        openList.removeAtIndex(find(openList.array, neighbour)!)
                        openList.add(neighbour)
                    }
                } else {
                    // Set the parent of the node
                    neighbour.parent = currentNode
                    
                    // Calculate the g value
                    neighbour.gValue = currentNode.gValue + moveCost
                    
                    // Calculate the h value
                    neighbour.hValue = map.hValueForNode(neighbour, endNode: endNode)
                    
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
