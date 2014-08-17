//
//  Coordinates.swift
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

/// Coordinates stores coordinate of any type of coordinate system
@objc(PFCoordinates)
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
