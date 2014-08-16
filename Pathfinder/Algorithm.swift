//
//  Algorithm.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public protocol Algorithm: class {

    class func findPathInMap(map: Map, startNode: Node, endNode: Node) -> [Node]
    
}
