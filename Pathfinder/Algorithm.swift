//
//  Algorithm.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

/// Algorithm is a protocol that defines the interface for the pathfinding algorithm implementations
@objc(PFAlgorithm)
public protocol Algorithm: class {

    /// Finds the best path in a map from point A to B
    @objc
    class func findPathInMap(map: Map, startNode: Node, endNode: Node) -> [Node]
    
}
