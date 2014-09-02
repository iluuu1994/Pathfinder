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

enum DraggingOperation {
    case Start, End, Toggle
}

class GridView: UIView {
    
    private var _nodes: Matrix<Node>!
    private var _grid: Grid!
    private var _startNodeView: NodeView!
    private var _endNodeView: NodeView!
    private var _draggingOperation = DraggingOperation.Toggle
    private var _draggingNode: NodeView?
    private var _nodeViews: Matrix<NodeView!>!
    private var _cachedPath: [Node]?
    
    @IBOutlet
    private var durationLabel: UILabel!
    
    override func awakeFromNib() {
        _nodeViews = Matrix<NodeView!>(width: _gridSize, height: _gridSize, repeatedValue: { (x, y) in
            return nil
        })
        _nodes = Matrix(width: _gridSize, height: _gridSize) {
            (x, y) -> Node in
            return Node(coordinates: Coordinates2D(x: x, y: y))
        }

        _grid = Grid(nodes: self._nodes)
        
        // Create a node view for all nodes
        for (x, y, node) in _nodes {
            let nodeView = addNodeView(x, y)
            _nodeViews[x,y] = nodeView
            if x == 0 && y == 0 { _startNodeView = nodeView }
            if x == 1 && y == 0 { _endNodeView = nodeView }
        }
        
        _startNodeView.type = .Start
        _endNodeView.type = .End
    }
    
    func addNodeView(x: Int, _ y: Int) -> NodeView {
        let nodeWidth: CGFloat = bounds.size.width / CGFloat(_gridSize) * 0.5
        let nodeHeight: CGFloat = bounds.size.height / CGFloat(_gridSize) * 0.5
        
        let node = _nodes[x, y]
        let nodeView = NodeView(
            frame: CGRect(x: CGFloat(x) * nodeWidth, y: CGFloat(y) * nodeHeight, width: nodeWidth, height: nodeHeight),
            node: node
        )
        addSubview(nodeView)
        
        return nodeView
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            let view = hitTest(touch.locationInView(self), withEvent: event)
            if let nodeView = view as? NodeView {
                performOperation(_draggingOperation, onNodeView: nodeView, began: true)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            let view = hitTest(touch.locationInView(self), withEvent: event)
            if let nodeView = view as? NodeView {
                performOperation(_draggingOperation, onNodeView: nodeView, began: false)
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        _draggingNode = nil
        _draggingOperation = .Toggle
    }
    
    func performOperation(op: DraggingOperation, onNodeView nodeView: NodeView, began: Bool) {
        if _draggingNode === nodeView { return }
        _draggingNode = nodeView
        
        if began {
            switch nodeView.type {
                case .Start:
                    self._draggingOperation = .Start
                case .End:
                    self._draggingOperation = .End
                default:
                    self._draggingOperation = .Toggle
                    break
            }
        }
        
        switch op {
            case .Start:
                switch nodeView.type {
                    case .Empty:
                        _startNodeView.type = .Empty
                        _startNodeView = nodeView
                        _startNodeView.type = .Start
                    default:
                        break
                }
            break
            case .End:
                switch nodeView.type {
                    case .Empty:
                        _endNodeView.type = .Empty
                        _endNodeView = nodeView
                        _endNodeView.type = .End
                    default:
                        break
                }
                break
            case .Toggle:
                switch nodeView.type {
                    case .Empty:
                        nodeView.type = .Obstacle
                    case .Obstacle:
                        nodeView.type = .Empty
                    default:
                        break
                }
        }
    }
    
    func resetPath() {
        for (x, y, node) in _nodes {
            node.reset()
        }
        
        for (x, y, nodeView) in _nodeViews {
            if nodeView.node.parent != nil { nodeView.node.parent = nil }
            if nodeView.partOfPath { nodeView.partOfPath = false }
            
            nodeView.setNeedsDisplay()
        }
    }
    
    @IBAction
    func startPathfinder(sender: AnyObject) {
        resetPath()
        
        let duration = measureTime {
            self._cachedPath = AStarAlgorithm.findPathInMap(self._grid, startNode: self._startNodeView.node, endNode: self._endNodeView.node)
        }
        
        for node in _cachedPath! {
            let coords = node.coordinates as Coordinates2D
            if let nodeView = _nodeViews[coords.x, coords.y] {
                nodeView.partOfPath = true
            }
        }
        
        for (x, y, node) in _nodes {
            if let nodeView = _nodeViews[x, y] {
                if nodeView.node.parent != nil { nodeView.setNeedsDisplay() }
            }
        }
        
        durationLabel.text = "Duration: \(duration) seconds"
    }
    
}
