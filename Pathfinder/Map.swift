//
//  Map.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

// Map is an abstract class that can be overridden to created any type of map
public class Map {
    
    // -----------------
    // MARK: - Methods -
    // -----------------
    
    func validMoves(node: Node) -> [Node] {
        assert(false, "Unimplemented")
        return []
    }
    
    func hValueForNode(node: Node, endNode: Node) -> Int {
        assert(false, "Unimplemented")
        return 0
    }
    
    func moveCostForNode(node: Node, toNode: Node) -> Int {
        assert(false, "Unimplemented")
        return 0
    }
    
    func precalculateHValue(endNode: Node) {
        assert(false, "Unimplemented")
    }
    
}
