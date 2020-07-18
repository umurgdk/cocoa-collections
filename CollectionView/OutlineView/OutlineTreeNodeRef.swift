//
//  OutlineTreeNodeRef.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/18.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

// TODO: NSOutlineView requires items to be a reference type. Otherwise programmatic open/collapse operations
// doesn't work. Some says Apple supports value types conforming to Hashable protocol should also be working.
class OutlineTreeNodeRef {
    let node: AnyOutlineTreeNode
    let isGroup: Bool

    let buildView: (NSOutlineView) -> NSTableCellView
    var children: [OutlineTreeNodeRef]

    private(set) var indexPath: IndexPath

    // TODO: Must handle re ordering with updating children array order and each indexPath including self indexPath
    //       So this is a stateful component.
    
    init<Node: OutlineTreeNode>(_ node: Node, isGroup: Bool, viewBuilder: OutlineViewBuilder<Node>, indexPath: IndexPath) {
        self.node = node.anyTreeNode
        self.buildView = { viewBuilder.build(outlineView: $0, item: node) }
        self.isGroup = isGroup
        self.indexPath = indexPath
        
        // TODO: this is a problem for big data sets, child refs should be created on demand
        self.children = node.children.enumerated().map { index, child in
            OutlineTreeNodeRef(child, isGroup: false, viewBuilder: viewBuilder.childBuilder, indexPath: indexPath + [index])
        }
    }
}
