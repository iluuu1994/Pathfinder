//
//  Helpers.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 16/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

/// Measures the time of a closure
public func measureTime(block: () -> ()) -> Double {
    // Record start time
    let start = NSDate()
    // Execute the closure
    block()
    // Record end time
    let end = NSDate()
    
    // Calculate and return the delta time
    return end.timeIntervalSinceDate(start)
}

/// Build a path from linked nodes
internal func backtracePath(endNode: Node) -> [Node] {
    var route = [endNode]
    
    // Recursive lookup of the nodes parent
    while let parent = route.first?.parent {
        route.insert(parent, atIndex: 0)
    }
    
    return route
}
