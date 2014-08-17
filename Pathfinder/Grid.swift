//
//  Grid.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation


// ---------------------------------------------------------------------
// MARK: - Coordinates2D -
// ---------------------------------------------------------------------

/// Entity that stores 2d coordinates
@objc(PFCoordinates2D)
public class Coordinates2D: Coordinates {
    
    // --------------------
    // MARK: - Properties -
    // --------------------
    
    /// The x coordinate
    @objc
    public let x: Int
    
    /// The y coordinate
    @objc
    public let y: Int
    
    /// Inits the object using both x and y coordinate
    @objc
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    
    
    // -----------------
    // MARK: - Methods -
    // -----------------
    
    override public func toArray() -> [Int] {
        return [x, y]
    }
    
    
    // ------------------
    // MARK: - Hashable -
    // ------------------
    
    // TODO: "Error: Declarations in extensions cannot override yet". 
    // Move this to the extension once that feature is supported by Swift.
    //
    // Combines the x and y value as a hash
    // http://en.wikipedia.org/wiki/Cantor%5Fpairing%5Ffunction#Cantor_pairing_function
    override public var hashValue: Int {
        return (x + y)*(x + y + 1)/2 + y
    }
}

// -------------------
// MARK: - Printable -
// -------------------
extension Coordinates2D: Printable {
    public var description: String {
        return "(\(x),\(y))"
    }
}

// ------------------
// MARK: - Hashable -
// ------------------
extension Coordinates2D: Hashable {}

// -------------------
// MARK: - Equatable -
// -------------------
extension Coordinates2D: Equatable {}
public func ==(lhs: Coordinates2D, rhs: Coordinates2D) -> Bool {
    return (lhs.x == rhs.x && lhs.y == rhs.y)
}



// ---------------------------------------------------------------------
// MARK: - Grid2D -
// ---------------------------------------------------------------------

/// Grid is an implementation of a 2d map
@objc(PFGrid)
public class Grid: Map {
    
    // --------------------
    // MARK: - Properties -
    // --------------------
    
    /// The matrix stores the tiles of the map
    private let _nodes: Matrix<Node>
    
    /// Indicates if the path is allowed to use diagonal moves
    // FIXME: Sometimes the path makes weird detours
    // FIXME: Allows making directional moves when there are adjacent neighbours
    @objc
    public var allowsDiagonalMoves = false
    
    /// Indicates if the path is allowed to use diagonal moves next to a corner
    // NOTE: Unimplemented
    // TODO: Implement
    @objc
    public var allowsCuttingCorners = true
    
    /// The accuracy of the pathfinding (0 - infinity)
    private let _accuracy: Double = 0.25
    
    
    
    // --------------
    // MARK: - Init -
    // --------------
    
    /// Init the map using the 2d grid
    // TODO: @objc once Matrix is @objc
    public init(nodes: Matrix<Node>) {
        _nodes = nodes
    }
    
    
    
    // -----------------
    // MARK: - Methods -
    // -----------------

    /// Returns the valid moves that can be performed from one node to the other
    override internal func validMoves(node: Node) -> [Node] {
        let index = node.coordinates as Coordinates2D
        var moves = [Node]()
        
        // Those are the delta values from one node coordinate to the other
        let adjacentNeighbours = [(1, 0), (0, 1), (-1, 0), (0, -1)]
        let diagonalNeighbours = [(1, 1), (-1, 1), (-1, -1), (1, -1)]
        let neighbours = allowsDiagonalMoves ? adjacentNeighbours + diagonalNeighbours : adjacentNeighbours
        
        for (dX, dY) in neighbours {
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
    
    /// Calculates the move cost from one node to one of it's neighbour nodes
    override internal func moveCostForNode(node: Node, toNode: Node) -> Double {
        let index = node.coordinates as Coordinates2D
        let toIndex = toNode.coordinates as Coordinates2D
        
        return ((abs(index.x - toIndex.x) > 0 && abs(index.y - toIndex.y) > 0) ? 1 : 1.4) * _accuracy
    }
    
    /// Calculates the h value of a node
    override internal func hValueForNode(node: Node, endNode: Node) -> Double {
        let coord1 = node.coordinates as Coordinates2D
        let coord2 = endNode.coordinates as Coordinates2D
        
        switch heuristicFunction {
            case .Manhattan:
                return Double(abs(coord1.x - coord2.x) + abs(coord1.y - coord2.y))
        }
    }
    
}
