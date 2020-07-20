//
//  OutlineView.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

public class OutlineView: NSView, NSOutlineViewDataSource, NSOutlineViewDelegate {
    let scrollView = NSScrollView()
    let outlineView = NSOutlineView()

    var rootNodes: [OutlineViewItemRef] = []

    public var onSelectionChange: (IndexPath) -> Void = { _ in }

    public init() {
        super.init(frame: .zero)

        addSubview(scrollView)

        outlineView.dataSource = self
        outlineView.delegate = self
        outlineView.selectionHighlightStyle = .sourceList
        outlineView.floatsGroupRows = false
        outlineView.headerView = nil
        outlineView.autoresizesOutlineColumn = false
        outlineView.autosaveExpandedItems = true
        outlineView.autosaveTableColumns = true
        outlineView.indentationPerLevel = 20

        let column = NSTableColumn(identifier: .init("OutlineViewColumn"))
        outlineView.addTableColumn(column)
        outlineView.outlineTableColumn = column

        scrollView.documentView = outlineView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasHorizontalScroller = false
        scrollView.hasVerticalScroller = true

        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadData() {
        outlineView.reloadData()
    }
    
    public func addSection<Item, ViewBuilder>(_ title: String, nodes: [Item], viewBuilder: ViewBuilder)
        where ViewBuilder: OutlineNestedViewBuilder,
              ViewBuilder.Item == Item
    {
        let section = OutlineSection(title: title, children: nodes)
        let viewBuilder = OutlineGroupHeaderViewBuilder().withChild(viewBuilder)
        let nodeRef = viewBuilder.makeTreeNodeRef(section, isGroup: true, indexPath: [rootNodes.count])
        rootNodes.append(nodeRef)
    }
    
    public func addSection<Item, ViewBuilder>(_ title: String, nodes: [Item], viewBuilder: ViewBuilder)
        where ViewBuilder: OutlineViewBuilder,
              ViewBuilder.Item == Item
    {
        let section = OutlineSection(title: title, children: nodes)
        let viewBuilder = OutlineGroupHeaderViewBuilder().withChild(viewBuilder)
        let nodeRef = viewBuilder.makeTreeNodeRef(section, isGroup: true, indexPath: [rootNodes.count])
        rootNodes.append(nodeRef)
    }

    public func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        (item as? OutlineViewItemRef)?.isGroup ?? false
    }

    public func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let item = item as? OutlineViewItemRef else {
            return rootNodes.count
        }

        return item.children.count
    }

    public func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let item = item as? OutlineViewItemRef else {
            return rootNodes[index]
        }

        return item.children[index]
    }

    public func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let item = item as? OutlineViewItemRef else {
            return nil
        }

        let view = item.buildView(outlineView)
        view.objectValue = item
        return view
    }

    public func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let item = item as? OutlineViewItemRef else {
            fatalError("unexpected item type")
        }

        return item.children.count > 0
    }

    public func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        guard let item = item as? OutlineViewItemRef else {
            fatalError("unexpected item type")
        }

        return !item.isGroup
    }

    public func outlineViewSelectionDidChange(_ notification: Notification) {
        let row = outlineView.selectedRow

        guard let item = outlineView.item(atRow: row) as? OutlineViewItemRef,
              !item.isGroup else {
            return
        }

        onSelectionChange(item.indexPath)
    }
}
