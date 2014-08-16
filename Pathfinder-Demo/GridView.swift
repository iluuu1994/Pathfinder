//
//  GridView.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import UIKit
import Pathfinder

private enum Direction {
    case None
    case Up
    case Down
    case Left
    case Right
    case UpRight
    case DownRight
    case UpLeft
    case DownLeft
}

private class TileView: UIView {
    private let _color: UIColor
    
    init(frame: CGRect, color: UIColor, direction: Direction, node: Node) {
        _color = color
        
        super.init(frame: frame)
        
        let valuesTextField = UITextField(frame: bounds)
        valuesTextField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        valuesTextField.textAlignment = .Center
        valuesTextField.font = UIFont.systemFontOfSize(6)
        valuesTextField.text = "\(node.hValue) + \(node.gValue) = \(node.fValue)"
        addSubview(valuesTextField)
        
        let textField = UITextField(frame: bounds)
        textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        textField.textAlignment = .Center
        
        switch direction {
            case .None:
                textField.text = ""
            case .Up:
                textField.contentVerticalAlignment = .Bottom
                textField.text = "↑"
            textField.text = "↓"
            case .Down:
                textField.contentVerticalAlignment = .Top
                textField.text = "↑"
            case .Left:
                textField.textAlignment = .Right
                textField.text = "→"
            case .Right:
                textField.textAlignment = .Left
                textField.text = "←"
            case .UpRight:
                textField.contentVerticalAlignment = .Bottom
                textField.textAlignment = .Left
                textField.text = "⇙"
            case .DownRight:
                textField.contentVerticalAlignment = .Top
                textField.textAlignment = .Left
                textField.text = "⇖"
            case .UpLeft:
                textField.contentVerticalAlignment = .Bottom
                textField.textAlignment = .Right
                textField.text = "⇘"
            case .DownLeft:
                textField.contentVerticalAlignment = .Top
                textField.textAlignment = .Right
                textField.text = "⇗"
        }
        
        addSubview(textField)
    }
    
    required init(coder aDecoder: NSCoder!) {
        _color = UIColor.blackColor()
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        _color.set()
        UIRectFill(rect)
        
        UIColor.blackColor().setStroke()
        UIBezierPath(rect: bounds).stroke()
    }
}

class GridView: UIView {
    
    override func awakeFromNib() {
        
        let width = 20
        let height = 20
        let from = (x: 0, y: 0)
        let to = (x: 19, y: 19)
        
        let matrix = Matrix(width: width, height: height) {
            (x, y) -> Node in
            return Node(coordinates: Coordinates2D(x: x, y: y))
        }
        
        let array =
           [[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
        
        for (y, subarray) in enumerate(array) {
            for (x, value) in enumerate(subarray) {
                if value == 1 {
                    let node = Node(coordinates: Coordinates2D(x: x, y: y))
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
            var direction = Direction.None
            
            if let parent = node.parent {
                let index = matrix.indexOfElement(node)!
                let parentIndex = matrix.indexOfElement(parent)!
                let deltaX = parentIndex.x > index.x ? -1 : (parentIndex.x < index.x ? 1 : 0)
                let deltaY = parentIndex.y > index.y ? -1 : (parentIndex.y < index.y ? 1 : 0)
                let delta = (deltaX, deltaY)
                
                direction = {
                    switch delta {
                        case (0,-1):
                            return Direction.Up
                        case (1,-1):
                            return Direction.UpRight
                        case (1,0):
                            return Direction.Right
                        case (1,1):
                            return Direction.DownRight
                        case (0,1):
                            return Direction.Down
                        case (-1,1):
                            return Direction.DownLeft
                        case (-1,0):
                            return Direction.Left
                        case (-1,-1):
                            return Direction.UpLeft
                        default:
                            return .None
                    }
                }()
            }
            
            let tileView = TileView(
                frame: CGRect(x: CGFloat(x) * tileWidth, y: CGFloat(y) * tileHeight, width: tileWidth, height: tileHeight),
                color: color,
                direction: direction,
                node: node
            )
            addSubview(tileView)
        }
        
        let start = NSDate(); // <<<<<<<<<< Start time
        
        let path = Algorithm.findPathInMap(map, startNode: matrix[from.x, from.y], endNode: matrix[to.x, to.y])
        
        let end = NSDate();   // <<<<<<<<<<   end time
        let timeInterval: Double = end.timeIntervalSinceDate(start); // <<<<< Difference in seconds (double)
        println("\(timeInterval) seconds");
        
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
