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
public class OutlineViewItemRef {
    let isGroup: Bool

    let buildView: (NSOutlineView) -> NSTableCellView
    var children: [OutlineViewItemRef]

    private(set) var indexPath: IndexPath
    
    init<VB: OutlineNestedViewBuilder>(_ node: VB.Item, isGroup: Bool, viewBuilder: VB, indexPath: IndexPath) {
        self.buildView = { viewBuilder.build(node, for: $0) }
        self.isGroup = isGroup
        self.indexPath = indexPath

        // TODO: this is a problem for big data sets, child refs should be created on demand
        self.children = node.children.lazy.enumerated().map { index, child in
            viewBuilder.childBuilder.makeTreeNodeRef(child, isGroup: false, indexPath: indexPath + [index])
        }
    }
    
    init<VB: OutlineViewBuilder>(_ node: VB.Item, isGroup: Bool, viewBuilder: VB, indexPath: IndexPath) {
        self.buildView = { viewBuilder.build(node, for: $0) }
        self.isGroup = isGroup
        self.indexPath = indexPath

        // TODO: this is a problem for big data sets, child refs should be created on demand
        self.children = []
    }
}
