//
//  Matrix.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 30/07/14.
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



// ----------------------
// MARK: - SequenceType -
// ----------------------

extension Matrix: SequenceType {
    /// Returns a generator to loop through the matrix
    public func generate() -> MatrixGenerator<T> {
        return MatrixGenerator(matrix: self)
    }
}

/// Generator used to enumerate through the matrix
public class MatrixGenerator<T>: GeneratorType {
    /// The backed matrix
    private let _matrix: Matrix<T>
    /// The current x value
    private var _x = 0
    /// The current y value
    private var _y = 0
    
    /// Init the matrix generator using the matrix
    init(matrix: Matrix<T>) {
        _matrix = matrix
    }
    
    /// Step through the matrix
    public func next() -> (x: Int, y: Int, element: T)? {
        // Sanity check
        if _x >= _matrix.width { return nil }
        if _y >= _matrix.height { return nil }
        
        // Extract the element and increase the counters
        let returnValue = (_x, _y, _matrix[_x, _y])
        
        // Increase the counters
        ++_x
        if _x >= _matrix.width {
            _x = 0
            ++_y
        }
        
        return returnValue
    }
    
}
