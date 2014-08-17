//
//  Node.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

@objc(PFNode)
public class Node: Printable, Hashable {
    
    // --------------
    // MARK: - Init -
    // --------------
    
    public init(coordinates: Coordinates) {
        self.coordinates = coordinates
    }
    
    
    // --------------------
    // MARK: - Properties -
    // --------------------
    
    // The coordinates of the node in the map
    public let coordinates: Coordinates
    
    // Indicates if the node is accessible
    public var accessible: Bool = true
    
    // Heuristic Value
    public var hValue: Double = 0.0
    
    // The total cost that incur when performing the move
    public var gValue: Double = 0.0
    
    // The total cost
    public var fValue: Double {
        return hValue + gValue
    }
    
    // The parent node is used to lead back to the start node
    public var parent: Node?
    
    // The has value to store the node in a set
    public var hashValue: Int {
        return coordinates.hashValue
    }
}



// -------------------
// MARK: - Printable -
// -------------------

extension Node: Printable {

    public var description: String {
        return "<Node at:\(coordinates) h:\(hValue) g:\(gValue) f:\(fValue)>"
    }
    
}


// -------------------
// MARK: - Equatable -
// -------------------

extension Node: Equatable {}
public func ==(l: Node, r: Node) -> Bool {
    return l === r
}
