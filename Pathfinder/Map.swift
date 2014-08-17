//
//  Map.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

/// Map is an abstract class that can be overridden to created any type of map
/// TODO: I ran into issues when making the Map a protocol. I'll try to do this in the future.
@objc(PFMap)
public class Map {
    
    // --------------------
    // MARK: - Properties -
    // --------------------
    
    /// The function used to calculate the heuristic value
    var heuristicFunction: HeuristicFunction = .Manhattan
    
    
    
    // -----------------
    // MARK: - Methods -
    // -----------------
    
    /// Returns the valid moves that can be performed from one node to the other
    func validMoves(node: Node) -> [Node] {
        assert(false, "Unimplemented")
        return []
    }
    
    /// Calculates the hValue from a node to the end node
    func hValueForNode(node: Node, endNode: Node) -> Double {
        assert(false, "Unimplemented")
        return 0
    }
    
    /// Calculates the move cost from one node to one of it's neighbour nodes
    func moveCostForNode(node: Node, toNode: Node) -> Double {
        assert(false, "Unimplemented")
        return 0
    }
    
}
