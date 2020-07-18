//
//  OutlineTreeNode.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

protocol OutlineTreeNode {
    associatedtype Child: OutlineTreeNode
    
    var numberOfChildren: Int { get }
    var children: [Child] { get }
    
    func child(at index: Int) -> Child?
}

extension OutlineTreeNode {
    var anyTreeNode: AnyOutlineTreeNode {
        AnyOutlineTreeNode(self)
    }
}

extension OutlineTreeNode where Child.Child == Child {
    func child(at indexPath: IndexPath) -> Child? {
        guard !indexPath.isEmpty else { return nil }

        var indexPath = indexPath
        var child: Child? = self.child(at: indexPath.removeFirst())

        while !indexPath.isEmpty && child != nil {
            let nextIndex = indexPath.removeFirst()
            child = child?.child(at: nextIndex)
        }

        return child
    }
}

extension Array: OutlineTreeNode where Element: OutlineTreeNode {
    var numberOfChildren: Int {
        count
    }

    var children: [Element] {
        self
    }

    func child(at index: Int) -> Element? {
        self[index]
    }
}

class AnyOutlineTreeNode: OutlineTreeNode {
    private let getNumberOfChildren: () -> Int
    private let getChildren: () -> [AnyOutlineTreeNode]
    private let getChildAt: (Int) -> AnyOutlineTreeNode?

    var numberOfChildren: Int {
        getNumberOfChildren()
    }

    var children: [AnyOutlineTreeNode] {
        getChildren()
    }


    func child(at index: Int) -> AnyOutlineTreeNode? {
        getChildAt(index)
    }

    init<Node: OutlineTreeNode>(_ node: Node) {
        self.getNumberOfChildren = { node.numberOfChildren }
        self.getChildren = { node.children.lazy.map { AnyOutlineTreeNode($0) } }
        self.getChildAt = { node.child(at: $0).map { AnyOutlineTreeNode($0) } }
    }
}
