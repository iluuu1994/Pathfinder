//
//  GridView.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import UIKit
import Pathfinder

class GridView: UIView {
    
    override func awakeFromNib() {
        
        let width = 10
        let height = 10
        let from = (x: 0, y: 0)
        let to = (x: 5, y: 9)
        
        let matrix = Matrix(width: width, height: height) {
            (x, y) -> Node in
            return Node(coordinates: GridCoordinates(x: x, y: y))
        }
        
        let array =
           [[0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0]]
        
        for (y, subarray) in enumerate(array) {
            for (x, value) in enumerate(subarray) {
                if value == 1 {
                    let node = Node(coordinates: GridCoordinates(x: x, y: y))
                    node.accessible = false
                    matrix[x, y] = node
                }
            }
        }
        
        let map = Grid(nodes: matrix)
        
        let tileWidth: CGFloat = bounds.size.width / CGFloat(width) * 0.5
        let tileHeight: CGFloat = bounds.size.height / CGFloat(height) * 0.5
        
        func addWithColor(x: Int, y: Int, color: UIColor) {
            let node = matrix[x, y]
            let tileView = NodeView(
                frame: CGRect(x: CGFloat(x) * tileWidth, y: CGFloat(y) * tileHeight, width: tileWidth, height: tileHeight),
                color: color,
                node: node
            )
            addSubview(tileView)
        }
        
        var path: [Node]!
        measureTime("A*") {
            path = AStarAlgorithm.findPathInMap(map, startNode: matrix[from.x, from.y], endNode: matrix[to.x, to.y])
        }
        
        for x in 0..<matrix.width {
            for y in 0..<matrix.height {
                let node = matrix[x, y]
                addWithColor(x, y, node.accessible ? UIColor.lightGrayColor() : UIColor.blackColor())
            }
        }
        
        for node in path {
            let index = matrix.indexOfElement(node)!
            addWithColor(index.x, index.y, UIColor.blueColor())
        }
        
        addWithColor(from.x, from.y, UIColor.redColor())
        addWithColor(to.x, to.y, UIColor.greenColor())
        
    }
    
}
