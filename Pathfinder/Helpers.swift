//
//  Helpers.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 16/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public func measureTime(name: String, block: () -> ()) {

    let start = NSDate(); // <<<<<<<<<< Start time
    
    block()
    
    let end = NSDate();   // <<<<<<<<<<   end time
    println("\(name): \(end.timeIntervalSinceDate(start)) seconds");
    
}

public func backtracePath(endNode: Node) -> [Node] {
    var route = [endNode]
    while let parent = route.first?.parent {
        route.insert(parent, atIndex: 0)
    }
    
    return route
}
