//
//  OutlineItemBuilder.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

public protocol OutlineViewBuilder {
    associatedtype Item
    func build(_ item: Item, for outlineView: NSOutlineView) -> NSTableCellView
    func makeTreeNodeRef(_ item: Item, isGroup: Bool, indexPath: IndexPath) -> OutlineViewItemRef
}

public protocol OutlineNestedViewBuilder: OutlineViewBuilder where Item: OutlineTreeNode {
    associatedtype ChildBuilder: OutlineViewBuilder where ChildBuilder.Item == Item.Child
    var childBuilder: ChildBuilder { get }
    func makeTreeNodeRef(_ item: Item, isGroup: Bool, indexPath: IndexPath) -> OutlineViewItemRef
}

extension OutlineViewBuilder {
    public func makeTreeNodeRef(_ item: Item, isGroup: Bool, indexPath: IndexPath) -> OutlineViewItemRef {
        OutlineViewItemRef(item, isGroup: isGroup, viewBuilder: self, indexPath: indexPath)
    }
}

extension OutlineNestedViewBuilder {
    public func makeTreeNodeRef(_ item: Item, isGroup: Bool, indexPath: IndexPath) -> OutlineViewItemRef {
        OutlineViewItemRef(item, isGroup: isGroup, viewBuilder: self, indexPath: indexPath)
    }
}

public struct OutlineViewBuilderRecursive<VB: OutlineViewBuilder>: OutlineNestedViewBuilder
where
    VB.Item: OutlineTreeNode,
    VB.Item.Child == VB.Item
{
    public let builder: VB
    public var childBuilder: Self {
        OutlineViewBuilderRecursive(builder: builder)
    }
    
    public func build(_ item: VB.Item, for outlineView: NSOutlineView) -> NSTableCellView {
        builder.build(item, for: outlineView)
    }
}

public struct OutlineViewBuilderWithChild<Parent: OutlineViewBuilder, Child: OutlineViewBuilder>: OutlineNestedViewBuilder where
    Parent.Item: OutlineTreeNode,
    Child.Item == Parent.Item.Child
{
    public let parent: Parent
    public let childBuilder: Child
    
    public func build(_ item: Parent.Item, for outlineView: NSOutlineView) -> NSTableCellView {
        parent.build(item, for: outlineView)
    }
}

extension OutlineViewBuilder where Item: OutlineTreeNode {
    public func withChild<ChildBuilder: OutlineViewBuilder>(_ childBuilder: ChildBuilder) -> OutlineViewBuilderWithChild<Self, ChildBuilder> {
        OutlineViewBuilderWithChild(parent: self, childBuilder: childBuilder)
    }
}

extension OutlineViewBuilder where Item: OutlineTreeNode, Item.Child == Item {
    public func recursive() -> OutlineViewBuilderRecursive<Self> {
        OutlineViewBuilderRecursive(builder: self)
    }
}

public struct StringViewBuilder: OutlineViewBuilder {
    public init() {
    }
    
    public func build(_ string: String, for outlineView: NSOutlineView) -> NSTableCellView {
        let cell = DefaultOutlineItemView()
        cell.configure(with: string)
        return cell
    }
    
    public static func map<T>(_ mapper: @escaping (T) -> String) -> StringViewBuilderMapper<T> {
        StringViewBuilderMapper(mapper)
    }
}

public struct StringViewBuilderMapper<T>: OutlineViewBuilder {
    private let map: (T) -> String
    private let stringBuilder = StringViewBuilder()
    
    public init(_ map: @escaping (T) -> String) {
        self.map = map
    }
    
    public func build(_ item: T, for outlineView: NSOutlineView) -> NSTableCellView {
        stringBuilder.build(map(item), for: outlineView)
    }
}
