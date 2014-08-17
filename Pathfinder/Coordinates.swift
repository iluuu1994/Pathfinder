//
//  Coordinate.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 16/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

/// Coordinates stores coordinate of any type of coordinate system
public class Coordinates {
    
    /// Wraps the coordinates in an array
    public func toArray() -> [Int] {
        assert(false, "`toArray` must be overridden in the Coordinates subclasses!")
        return []
    }
    
    
    // ------------------
    // MARK: - Hashable -
    // ------------------
    
    // TODO: "Error: Declarations in extensions cannot override yet".
    // Move this to the extension once that feature is supported by Swift.
    public var hashValue: Int {
        return 0
    }
    
}


// ------------------
// MARK: - Hashable -
// ------------------

extension Coordinates: Hashable {
    
}


// -------------------
// MARK: - Equatable -
// -------------------

extension Coordinates: Equatable {}
public func ==(lhs: Coordinates, rhs: Coordinates) -> Bool {
    return lhs === rhs
}
