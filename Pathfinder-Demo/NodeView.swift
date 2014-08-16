//
//  NodeView.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 16/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import UIKit
import Pathfinder

public class NodeView: UIView {
    private let _color: UIColor
    
    init(frame: CGRect, color: UIColor, node: Node) {
        _color = color
        
        super.init(frame: frame)
        
        let valuesTextField = UITextField(frame: bounds)
        valuesTextField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        valuesTextField.textAlignment = .Center
        valuesTextField.font = UIFont.systemFontOfSize(5)
        valuesTextField.text = "\(node.hValue) + \(node.gValue) = \(node.fValue)"
        addSubview(valuesTextField)
        
        let textField = UITextField(frame: bounds)
        textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        textField.textAlignment = .Center
        
        
        var direction = Direction.None
        if let parent = node.parent {
            let index = node.coordinates as GridCoordinates
            let parentIndex = parent.coordinates as GridCoordinates
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
    
    required public init(coder aDecoder: NSCoder!) {
        _color = UIColor.blackColor()
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
        _color.set()
        UIRectFill(rect)
        
        UIColor.blackColor().setStroke()
        UIBezierPath(rect: bounds).stroke()
    }
}

