//
//  Node.swift
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
    public var hValue: Int = 0
    
    /// Move Cost (+ move cost of parent)
    @objc
    public var gValue: Int = 0
    
    /// The total cost (h + g)
    @objc
    public var fValue: Int {
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
