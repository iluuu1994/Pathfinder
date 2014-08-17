//
//  SortedArray.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 17/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import Foundation

/// An array that is always sorted by an index
public class IndexedArray<T, U : Comparable> {
    
    public private(set) var array = [T]()
    private let _extractIndex: (T) -> U
    public private(set) var count = 0
    
    public init(extractIndex: (T) -> U) {
        _extractIndex = extractIndex
    }
    
    public func add(element: T) {
        let index = findIndex(element)
        
        if index == array.count {
            array.append(element)
        } else {
            array.insert(element, atIndex: index)
        }
    }
    
    public func removeAtIndex(index: Int) {
        array.removeAtIndex(index)
    }
    
    private func findIndex(element: T) -> Int {
        // The value that the array is ordered by
        let orderValue = _extractIndex(element)
        // The index we're currently using
        var currentSlice = sliceIndex(array.count)
        var currentIndex = currentSlice
        // Return 0 if there are no elements
        if array.count == 0 { return 0 }
        
        while currentIndex >= 0 && currentIndex <= array.count {
            var correctIndex = true
            var forward = true
            // Current Element
            if let currentElement = (currentIndex < array.count) ? array[currentIndex] : nil {
                let currentOrderValue = _extractIndex(currentElement)
                if currentOrderValue < orderValue { correctIndex = false }
            }
            if let previousElement = (currentIndex-1 >= 0) ? array[currentIndex-1] : nil {
                let previousOrderValue = _extractIndex(previousElement)
                if previousOrderValue > orderValue {
                    correctIndex = false
                    forward = false
                }
            }
            
            if correctIndex { return currentIndex }
            
            // See if the smaller
            // Set the index that should be checked next
            if currentSlice <= 1 { break }
            currentSlice = sliceIndex(currentSlice)
            currentIndex += forward ? currentSlice : -currentSlice
        }
        
        return 0
    }
    
    private func sliceIndex(index: Int) -> Int {
        return Int(ceil(Double(index) / 2.0))
    }
    
}
