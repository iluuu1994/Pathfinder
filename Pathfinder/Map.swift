//
//  Map.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
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
    func hValueForNode(node: Node, endNode: Node) -> Int {
        assert(false, "Unimplemented")
        return 0
    }
    
    /// Calculates the move cost from one node to one of it's neighbour nodes
    func moveCostForNode(node: Node, toNode: Node) -> Int {
        assert(false, "Unimplemented")
        return 0
    }
    
}
