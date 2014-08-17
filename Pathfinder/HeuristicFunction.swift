//
//  HeuristicFunction.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 17/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

/// Lists the functions that can be used to calculate the heuristic value
public enum HeuristicFunction {
    /// dX + dY (+ dZ)
    case Manhattan
}
