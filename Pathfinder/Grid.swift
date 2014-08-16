//
//  Grid.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public class GridCoordinates: Coordinates, Printable {
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public var description: String {
        return "(\(x),\(y))"
    }
}


public class Grid: Map {
    
    // --------------------
    // MARK: - Properties -
    // --------------------
    
    private let _nodes: Matrix<Node>
    
    
    
    // --------------
    // MARK: - Init -
    // --------------
    
    public init(nodes: Matrix<Node>) {
        _nodes = nodes
    }
    
    
    
    // -----------------
    // MARK: - Methods -
    // -----------------

    override public func validMoves(node: Node) -> [Node] {
        let index = _nodes.indexOfElement(node)!
        var moves = [Node]()
        
        for (dX, dY) in [(1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1), (0, -1), (1, -1)] {
            let x = index.x + dX
            let y = index.y + dY
            
            if x >= 0 && x < _nodes.width {
                if y >= 0 && y < _nodes.height {
                    moves.append(_nodes[x, y])
                }
            }
        }
        
        return moves
    }
    
    override public func hValueForNode(node: Node, endNode: Node) -> Int {
        // TODO: Don't unsave cast!
        let index = node.coordinates as GridCoordinates
        let endIndex = endNode.coordinates as GridCoordinates
        
        return abs(endIndex.x - index.x) + abs(endIndex.y - index.y)
    }
    
    override public func moveCostForNode(node: Node, toNode: Node) -> Int {
        let index = node.coordinates as GridCoordinates
        let toIndex = toNode.coordinates as GridCoordinates
        
        return (abs(index.x - toIndex.x) > 0 && abs(index.y - toIndex.y) > 0) ? 14 : 10
    }
    
    override public func precalculateHValue(endNode: Node) {
        for x in 0..<_nodes.width {
            for y in 0..<_nodes.height {
                let node = _nodes[x, y]
                node.hValue = hValueForNode(node, endNode: endNode)
            }
        }
    }
    
}
