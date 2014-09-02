//
//  IndexedArray.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 17/08/14.
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
    
    /// Force-sort if the index values were changed
    public func sort() {
        array.sort { self._extractIndex($0) < self._extractIndex($1) }
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
        
        var iterations = 0
        var wentToZero = false
        while arrayIndex >= 0 && arrayIndex <= array.count {
            iterations++
            // Is this the correct index?
            var correctIndex = true
            var forward = true
            
            if arrayIndex == 0 { wentToZero = true }
            
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
            // Halve the slice again
            currentSlice = halveIndex(currentSlice)
            // Depending on the size of the index we either lower or raise the index
            arrayIndex += forward ? currentSlice : -currentSlice
        }
        
        // There was nothing found, we just return 0
        return 0
    }
    
    /// Halves the index (floor(x / 2.0))
    /// The index can't be 0 though
    private func halveIndex(index: Int) -> Int {
        let index = Int(floor(Double(index) / 2.0))
        return index > 0 ? index : 1
    }
    
}
