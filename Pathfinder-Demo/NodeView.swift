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
    
    public enum Type {
        case Empty, Start, End, Obstacle
    }
    
    public let node: Node
    private var _type: Type = .Empty
    
    private var _partOfPath: Bool = false
    public var partOfPath: Bool {
        get {
            return _partOfPath
        }
        set(newValue) {
            _partOfPath = newValue
            setNeedsDisplay()
        }
    }
    
    public var type: Type {
        get {
            return _type
        }
        set(newType) {
            _type = newType
            
            switch _type {
                case .Obstacle:
                    node.accessible = false
                default:
                    node.accessible = true
            }
            
            setNeedsDisplay()
        }
    }
    
    private var _color: UIColor {
        switch _type {
            case .Empty:
                return !partOfPath ? (node.parent == nil ? UIColor(white: 1.0, alpha: 1.0) : // Default
                                                           UIColor(red: 0.83, green: 0.93, blue: 1.0, alpha: 1.0)) : // Open List
                                                           UIColor(red: 0.43, green: 0.7, blue: 0.9, alpha: 1.0) // Path
            case .Obstacle:
                return UIColor(white: 0.7, alpha: 1.0)
            case .Start:
                return UIColor(red: 0.75, green: 0.23, blue: 0.19, alpha: 1.0)
            case .End:
                return UIColor(red: 0.22, green: 0.8, blue: 0.46, alpha: 1.0)
            default:
                node.accessible = true
        }
    }
    
    init(frame: CGRect, node: Node) {
        self.node = node
        super.init(frame: frame)
    }
    
    // Compiler, shut up!
    required public init(coder aDecoder: NSCoder!) {
        self.node = Node(coordinates: GridCoordinates(x: 0, y: 0))
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
        _color.set()
        UIRectFill(rect)
        
        UIColor(white: 0.0, alpha: 0.3).setStroke()
        UIBezierPath(rect: bounds).stroke()
    }
}

