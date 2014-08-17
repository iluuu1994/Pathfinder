//
//  Node.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

/// Defines a unit on a map
@objc(PFNode)
public class Node {
    
    // --------------
    // MARK: - Init -
    // --------------
    
    /// Init the node using it's coordinate
    /// The coordinate never changes
    @objc
    public init(coordinates: Coordinates) {
        self.coordinates = coordinates
    }
    
    
    // --------------------
    // MARK: - Properties -
    // --------------------
    
    /// The coordinates of the node in the map
    @objc
    public let coordinates: Coordinates
    
    /// Indicates if the node has been opened
    @objc
    public var opened: Bool = false
    
    /// Indicates if the node has been closed
    @objc
    public var closed: Bool = false
    
    /// Indicates if the node is accessible
    @objc
    public var accessible: Bool = true
    
    /// Heuristic Value
    @objc
    public var hValue: Double = 0.0
    
    /// Move Cost (+ move cost of parent)
    @objc
    public var gValue: Double = 0.0
    
    /// The total cost (h + g)
    @objc
    public var fValue: Double {
        return hValue + gValue
    }
    
    /// The parent node is used to lead back to the start node
    @objc
    public var parent: Node?
    
    
    
    // -----------------
    // MARK: - Methods -
    // -----------------
    
    /// Reset the nodes properties
    @objc
    public func reset() {
        opened = false
        closed = false
        hValue = 0
        gValue = 0
        parent = nil
    }
    
}



// ------------------
// MARK: - Hashable -
// ------------------

extension Node: Hashable {
    @objc
    public var hashValue: Int {
        return coordinates.hashValue
    }
}



// -------------------
// MARK: - Printable -
// -------------------

extension Node: Printable {
    @objc
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
