//
//  Matrix.swift
//  2048
//
//  Created by Ilija Tovilo on 30/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

/// A matrix is able to store values in 2 dimensional form
// TODO: Make Objective-C compatible
@objc(PFMatrix)
public class Matrix<T> {

    // --------------------
    // MARK: - Properties -
    // --------------------
    
    /// The width of the matrix
    public let width: Int
    
    /// The height of the matrix
    public let height: Int
    
    /// Backed array that stores the elements of the matrix
    private var _elements: [T]
    
    
    
    // --------------
    // MARK: - Init -
    // --------------
    
    /// Init the matrix with a width, height, and a repeated value
    /// The repeated value is used, because a matrix can never have empty indexes
    /// If you specifically need empty indexes, just use Optionals
    public init(width: Int, height: Int, repeatedValue: (x: Int, y: Int) -> T) {
        // Sanity check
        assert(width >= 0, "The width of the matrix needs to be larger or equal to 0.")
        assert(height >= 0, "The height of the matrix needs to be larger or equal to 0.")
        
        // Init the variables
        self.width = width
        self.height = height
        _elements = Array<T>(count: width*height, repeatedValue: repeatedValue(x: 0, y: 0))
        
        // Fill the matrix with the repeated value
        for x in 0..<width {
            for y in 0..<height {
                self[x, y] = repeatedValue(x: x, y: y)
            }
        }
    }
    
    
    
    // -------------------
    // MARK: - Subscript -
    // -------------------
    
    /// Gets an element in the matrix using it's x and y position
    public subscript(x: Int, y: Int) -> T {
        get {
            // Sanity check
            assert(x >= 0 && x < self.width, "x needs to be larger or equal to zero and smaller than the width of the matrix.")
            assert(y >= 0 && y < self.height, "y needs to be larger or equal to zero and smaller than the height of the matrix.")
            
            return _elements[x + (y * width)]
        }
        set(newValue) {
            // Sanity check
            assert(x >= 0 && x < self.width, "x needs to be larger or equal to zero and smaller than the width of the matrix.")
            assert(y >= 0 && y < self.height, "y needs to be larger or equal to zero and smaller than the height of the matrix.")
            
            _elements[x + (y * width)] = newValue
        }
    }
    
}
