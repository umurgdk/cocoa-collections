//
//  OutlineSection.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/19.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import Foundation

struct OutlineSection<Node>: OutlineTreeNode {
    typealias Child = Node
    let title: String
    let children: [Node]
    
    var numberOfChildren: Int { children.count }
    func child(at index: Int) -> Node? { children[index] }
}
