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
    
    /// Calculates the h value of two coordinates
    func calculateHeuristicValue(coordinates1: Coordinates, coordinates2: Coordinates) -> Double {
        // Both objects must have the same number of coordinates
        assert(coordinates1.toArray().count == coordinates2.toArray().count, "Both objects must have the same number of coordinates")
        
        var hValue: Double = 0.0
        
        /// Loop through each coordinate and apply the function
        for (index, coordinate) in enumerate(coordinates1.toArray()) {
            // Calculate the delta of the two coordinates
            let delta = abs(coordinate - coordinates2.toArray()[index])
            
            // Use the correct function
            switch self {
                case .Manhattan:
                    hValue += Double(delta)
            }
        }
        
        return hValue
    }
}
