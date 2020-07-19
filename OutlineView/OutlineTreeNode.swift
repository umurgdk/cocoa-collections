//
//  OutlineTreeNode.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

public protocol OutlineTreeNode {
    associatedtype Child
    
    var numberOfChildren: Int { get }
    var children: [Child] { get }
    
    func child(at index: Int) -> Child?
}

extension OutlineTreeNode where Child: OutlineTreeNode, Child.Child == Child {
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
    public var numberOfChildren: Int {
        count
    }

    public var children: [Element] {
        self
    }

    public func child(at index: Int) -> Element? {
        self[index]
    }
}
