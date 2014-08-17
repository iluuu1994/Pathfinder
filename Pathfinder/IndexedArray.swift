//
//  SortedArray.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 17/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

/// An array that is always sorted by an index
/// This dramatically improves the performance of arrays that need to be sorted frequently
@objc(PFIndexedArray)
public class IndexedArray<T, U : Comparable> {
    
    // --------------------
    // MARK: - Properties -
    // --------------------
    
    /// The backed array
    public private(set) var array = [T]()
    
    /// A closure that extracts the index from an array element
    private let _extractIndex: (T) -> U
    
    
    
    // --------------
    // MARK: - Init -
    // --------------
    
    /// Init the IndexedArray using the index extraction closure
    public init(extractIndex: (T) -> U) {
        _extractIndex = extractIndex
    }
    
    
    
    // -----------------
    // MARK: - Methods -
    // -----------------
    
    /// Add an element to the array
    /// The element will automatically be inserted in the right place
    public func add(element: T) {
        // Find the correct index
        let index = findIndex(element)
        
        if index == array.count {
            // Append the element if the array is not long enough
            array.append(element)
        } else {
            // Finally, insert the element in the right index
            array.insert(element, atIndex: index)
        }
    }
    
    /// Removes the element at index from the array
    public func removeAtIndex(index: Int) {
        array.removeAtIndex(index)
    }
    
    /// Finds the correct index in the array for an element
    private func findIndex(element: T) -> Int {
        // The index that the array is ordered by
        let index = _extractIndex(element)
        // The index we're currently using
        var currentSlice = halveIndex(array.count)
        var arrayIndex = currentSlice
        // Return 0 if there are no elements
        if array.count == 0 { return 0 }
        
        while arrayIndex >= 0 && arrayIndex <= array.count {
            // Is this the correct index?
            var correctIndex = true
            var forward = true
            
            // Check if the element is correctly positioned
            if arrayIndex < array.count {
                let currentIndex = _extractIndex(array[arrayIndex])
                if currentIndex < index { correctIndex = false }
            }
            if arrayIndex-1 >= 0 {
                let previousIndex = _extractIndex(array[arrayIndex-1])
                if previousIndex > index {
                    correctIndex = false
                    forward = false
                }
            }
            
            // Return the index if it's correct
            if correctIndex { return arrayIndex }
            // If the slice gets one or smaller, further iteration is useless
            if currentSlice <= 1 { break }
            // Halve the slice again
            currentSlice = halveIndex(currentSlice)
            // Depending on the size of the index we either lower or raise the index
            arrayIndex += forward ? currentSlice : -currentSlice
        }
        
        // There was nothing found, we just return 0
        return 0
    }
    
    /// Halves the index (ceil(x / 2.0))
    private func halveIndex(index: Int) -> Int {
        return Int(ceil(Double(index) / 2.0))
    }
    
}
