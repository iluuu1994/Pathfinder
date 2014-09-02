//
//  NodeView.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 16/08/14.
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
                return UIColor(white: 0.4, alpha: 1.0)
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
    required public init(coder aDecoder: NSCoder) {
        self.node = Node(coordinates: Coordinates2D(x: 0, y: 0))
        super.init(coder: aDecoder)
    }
    
    override public func drawRect(rect: CGRect) {
        _color.set()
        UIRectFill(rect)
        
        UIColor(white: 0.0, alpha: 0.1).setStroke()
        UIBezierPath(rect: bounds).stroke()
    }
}

