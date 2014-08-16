//
//  Matrix.swift
//  2048
//
//  Created by Ilija Tovilo on 30/07/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

public class Matrix<T: Equatable> {

    // --------------------
    // MARK: - Properties -
    // --------------------
    
    public let width: Int
    public let height: Int
    private var _elements: [T]
    
    
    
    // --------------
    // MARK: - Init -
    // --------------
    
    public init(width: Int, height: Int, repeatedValue: (x: Int, y: Int) -> T) {
        assert(width >= 0, "The width of the matrix needs to be larger or equal to 0.")
        assert(height >= 0, "The height of the matrix needs to be larger or equal to 0.")
        
        self.width = width
        self.height = height
        
        _elements = Array<T>(count: width*height, repeatedValue: repeatedValue(x: 0, y: 0))
        
        // Fill the elements
        for x in 0..<width {
            for y in 0..<height {
                self[x, y] = repeatedValue(x: x, y: y)
            }
        }
    }
    
    

    // -----------------
    // MARK: - Methods -
    // -----------------
    
    private func indexOfElementInArray(element: T) -> Int? {
        for (index, eachElement) in enumerate(_elements) {
            if eachElement == element {
                return index
            }
        }
        
        return nil
    }
    
    public func indexOfElement(element: T) -> (x: Int, y: Int)? {
        if let index = indexOfElementInArray(element) {
            // Automatically floors down, since it's an int
            let y = index / width
            let x = index % width
            
            return (x: x, y: y)
        }
        
        return nil
    }
    
    
    
    // -------------------
    // MARK: - Subscript -
    // -------------------
    
    public subscript(x: Int, y: Int) -> T {
        get {
            assert(x >= 0 && x < self.width, "x needs to be larger or equal to zero and smaller than the width of the matrix.")
            assert(y >= 0 && y < self.height, "y needs to be larger or equal to zero and smaller than the height of the matrix.")
            
            return _elements[x + (y * width)]
        }
        set(newValue) {
            assert(x >= 0 && x < self.width, "x needs to be larger or equal to zero and smaller than the width of the matrix.")
            assert(y >= 0 && y < self.height, "y needs to be larger or equal to zero and smaller than the height of the matrix.")
            
            _elements[x + (y * width)] = newValue
        }
    }
    
}
