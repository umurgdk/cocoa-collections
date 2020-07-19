//
//  OutlineSection.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/19.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import Foundation

public struct OutlineSection<Node>: OutlineTreeNode {
    public typealias Child = Node
    public let title: String
    public let children: [Node]
    
    public var numberOfChildren: Int { children.count }
    public func child(at index: Int) -> Node? { children[index] }
}
