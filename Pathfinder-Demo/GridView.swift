//
//  GridView.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
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

private let _gridSize = 20

enum TouchOperation {
    case Start, End, Draw, Erase
}

class GridView: UIView {
    
    private var _nodes: Matrix<Node>!
    private var _grid: Grid!
    private var _startNodeView: NodeView!
    private var _endNodeView: NodeView!
    private var _touchOperation = TouchOperation.Draw
    private var _touchNode: NodeView?
    private var _nodeViews: Matrix<NodeView?>!
    private var _cachedPath: [Node]?
    
    override func awakeFromNib() {
        _nodeViews = Matrix<NodeView?>(width: _gridSize, height: _gridSize, repeatedValue: { (x, y) in
            return nil
        })
        _nodes = Matrix(width: _gridSize, height: _gridSize) {
            (x, y) -> Node in
            return Node(coordinates: Coordinates2D(x: x, y: y))
        }
        _grid = Grid(nodes: self._nodes)
        // Create a node view for all nodes
        for (x, y, _) in _nodes {
            _nodeViews[x,y] = addNodeView(x, y)
        }
        // Reset type's of node views.
        reset()
    }
    
    public func viewControllerDidLayoutSubviews() {
        let nodeWidth: CGFloat = bounds.size.width / CGFloat(_gridSize)
        let nodeHeight: CGFloat = bounds.size.height / CGFloat(_gridSize)
        for (x, y, _) in _nodes {
            let nodeView = _nodeViews[x,y]
            nodeView!.frame = CGRect(x: CGFloat(x) * nodeWidth, y: CGFloat(y) * nodeHeight, width: nodeWidth, height: nodeHeight)
        }
    }
    
    public func reset() {
        // Reset type's of node views, making all .Empty except for one
        // .Start and one .End .
        for (x, y, _) in _nodes {
            let nodeView = _nodeViews[x,y]!
            if x == 0 && y == 0 {
                nodeView.type = .Start
                _startNodeView = nodeView
            } else if x == _gridSize - 1 && y == _gridSize - 1 {
                nodeView.type = .End
                _endNodeView = nodeView
            } else {
                nodeView.type = .Empty
            }
        }
        resetPath()
    }
    
    func addNodeView(_ x: Int, _ y: Int) -> NodeView {
        let nodeWidth: CGFloat = bounds.size.width / CGFloat(_gridSize)
        let nodeHeight: CGFloat = bounds.size.height / CGFloat(_gridSize)
        
        let node = _nodes[x, y]
        let nodeView = NodeView(
            frame: CGRect(x: CGFloat(x) * nodeWidth, y: CGFloat(y) * nodeHeight, width: nodeWidth, height: nodeHeight),
            node: node
        )
        addSubview(nodeView)
        
        return nodeView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let view = hitTest(touch.location(in: self), with: event)
            if let nodeView = view as? NodeView {
                switch nodeView.type {
                case .Start:
                    _touchOperation = .Start
                case .End:
                    _touchOperation = .End
                case .Empty:
                    _touchOperation = .Draw
                case .Obstacle:
                    _touchOperation = .Erase
                }
                touchMoveTo(nodeView: nodeView)
                break;
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let view = hitTest(touch.location(in: self), with: event)
            if let nodeView = view as? NodeView {
                touchMoveTo(nodeView: nodeView)
                break;
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let view = hitTest(touch.location(in: self), with: event)
            if let nodeView = view as? NodeView {
                touchMoveTo(nodeView: nodeView)
                break;
            }
        }
        _touchOperation = .Draw
        _touchNode = nil
    }
    
    func touchMoveTo(nodeView: NodeView) {
        if _touchNode === nodeView { return }
        switch _touchOperation {
            case .Start:
                switch nodeView.type {
                    case .Empty:
                        _startNodeView.type = .Empty
                        _startNodeView = nodeView
                        _startNodeView.type = .Start
                    default:
                        break
                }
            case .End:
                switch nodeView.type {
                    case .Empty:
                        _endNodeView.type = .Empty
                        _endNodeView = nodeView
                        _endNodeView.type = .End
                    default:
                        break
                }
            default:
                let coord2 = nodeView.node.coordinates as! Coordinates2D
                if (_touchNode == nil) {
                    plotPoint(coord2.x,coord2.y)
                } else {
                    let coord1 = _touchNode?.node.coordinates as! Coordinates2D
                    plotLine(coord1.x,coord1.y,coord2.x,coord2.y)
                }
        }
        _touchNode = nodeView
    }
    
    func plotLine(_ x0:Int,_ y0:Int,_ x1:Int,_ y1:Int) {
        // Bresenham's line algorithm
        // https://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm#Algorithm
        // Creative Commons Attribution-ShareAlike 3.0 License
        if abs(y1 - y0) < abs(x1 - x0) {
            if x0 > x1 {
                plotLineLow(x1, y1, x0, y0)
            } else {
                plotLineLow(x0, y0, x1, y1)
            }
        } else {
            if y0 > y1 {
                plotLineHigh(x1, y1, x0, y0)
            } else {
                plotLineHigh(x0, y0, x1, y1)
            }
        }
    }
    
    func plotLineLow(_ x0:Int,_ y0:Int,_ x1:Int,_ y1:Int) {
        let dx = x1 - x0
        var dy = y1 - y0
        var yinc = 1
        if dy < 0 {
            yinc = -1
            dy = -dy
        }
        var D = 2*dy - dx
        var y = y0
        for x in x0...x1 {
            plotPoint(x,y)
            if D > 0 {
                y = y + yinc
                D = D - 2*dx
            }
            D = D + 2*dy
        }
    }
    
    func plotLineHigh(_ x0:Int,_ y0:Int,_ x1:Int,_ y1:Int) {
        var dx = x1 - x0
        let dy = y1 - y0
        var xinc = 1
        if dx < 0 {
            xinc = -1
            dx = -dx
        }
        var D = 2*dx - dy
        var x = x0
        for y in y0...y1 {
            plotPoint(x,y)
            if D > 0 {
                x = x + xinc
                D = D - 2*dy
            }
            D = D + 2*dx
        }
    }
    
    func plotPoint(_ x:Int,_ y:Int) {
        let nodeView = _nodeViews[x,y]!
        switch nodeView.type {
        case .Empty:
            if _touchOperation == .Draw {
                nodeView.type = .Obstacle
            }
        case .Obstacle:
            if _touchOperation == .Erase {
                nodeView.type = .Empty
            }
        default:
            break
        }
    }
    
    func resetPath() {
        for (_, _, node) in _nodes {
            node.reset()
        }
        
        for (_, _, nodeView) in _nodeViews {
            if nodeView!.node.parent != nil { nodeView!.node.parent = nil }
            if nodeView!.partOfPath { nodeView!.partOfPath = false }
            
            nodeView!.setNeedsDisplay()
        }
    }
    
    internal func findPath() {
        resetPath()
        
        self._cachedPath = AStarAlgorithm.findPathInMap(self._grid, startNode: self._startNodeView.node, endNode: self._endNodeView.node)

        for node in _cachedPath! {
            let coords = node.coordinates as! Coordinates2D
            if let nodeView = _nodeViews[coords.x, coords.y] {
                nodeView.partOfPath = true
            }
        }
        
        for (x, y, _) in _nodes {
            if let nodeView = _nodeViews[x, y] {
                if nodeView.node.parent != nil { nodeView.setNeedsDisplay() }
            }
        }
    }
    
}
