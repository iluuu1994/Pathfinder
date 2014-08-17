//
//  GridView.swift
//  Pathfinder
//
//  Created by Ilija Tovilo on 15/08/14.
//  Copyright (c) 2014 Ilija Tovilo. All rights reserved.
//

import UIKit
import Pathfinder

private let _gridSize = 10

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
    private var _nodeViews = [NodeView]()
    
    override func awakeFromNib() {
        _nodes = Matrix(width: _gridSize, height: _gridSize) {
            (x, y) -> Node in
            return Node(coordinates: GridCoordinates(x: x, y: y))
        }

        _grid = Grid(nodes: self._nodes)
        
        // Create a node view for all nodes
        for x in 0..<_nodes.width {
            for y in 0..<_nodes.height {
                let nodeView = addNodeView(x, y)
                _nodeViews += [nodeView]
                if x == 0 && y == 0 { _startNodeView = nodeView }
                if x == 1 && y == 0 { _endNodeView = nodeView }
            }
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
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        for touch in touches {
            let view = hitTest(touch.locationInView(self), withEvent: event)
            if let nodeView = view as? NodeView {
                performOperation(_draggingOperation, onNodeView: nodeView, began: true)
            }
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        for touch in touches {
            let view = hitTest(touch.locationInView(self), withEvent: event)
            if let nodeView = view as? NodeView {
                performOperation(_draggingOperation, onNodeView: nodeView, began: false)
            }
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
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
    
    func resetAllNodeViews() {
        for nodeView in _nodeViews {
            nodeView.partOfPath = false
        }
    }
    
    @IBAction
    func startPathfinder(sender: AnyObject) {
        let path = AStarAlgorithm.findPathInMap(_grid, startNode: _startNodeView.node, endNode: _endNodeView.node)
        for nodeView in _nodeViews {
            nodeView.partOfPath = contains(path, nodeView.node)
        }

//        var path: [Node]!
//        measureTime("A*") {
//            path = AStarAlgorithm.findPathInMap(_grid, startNode: _startNode, endNode: _endNode)
//        }
    }
    
}
