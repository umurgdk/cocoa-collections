//
//  OutlineView.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

protocol UserInterfaceIdentifiable {
    static var identifier: NSUserInterfaceItemIdentifier { get }
}

class OutlineView<Item: OutlineTreeNode>: NSView, NSOutlineViewDataSource, NSOutlineViewDelegate {
    let scrollView = NSScrollView()
    let outlineView = NSOutlineView()

    let rootNodes: [OutlineTreeNodeRef]
    let viewBuilder: OutlineViewBuilder<Item>

    var onSelectionChange: (IndexPath) -> Void = { _ in
    }

    init(rootNodes: [Item], viewBuilder: OutlineViewBuilder<Item>) {
        // TODO: Is it possible to create tree node refs on demand?
        self.rootNodes = rootNodes.enumerated().map { index, node in
            OutlineTreeNodeRef(node, isGroup: true, viewBuilder: viewBuilder, indexPath: [index])
        }
        
        self.viewBuilder = viewBuilder
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

        let column = NSTableColumn(identifier: viewBuilder.childBuilder.viewIdentifier)
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

    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        (item as? OutlineTreeNodeRef)?.isGroup ?? false
    }

    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        guard let item = item as? OutlineTreeNodeRef else {
            return rootNodes.count
        }

        return item.children.count
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        guard let item = item as? OutlineTreeNodeRef else {
            return rootNodes[index]
        }

        return item.children[index]
    }

    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        guard let item = item as? OutlineTreeNodeRef else {
            return nil
        }

        let view = item.buildView(outlineView)
        view.objectValue = item
        return view
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        guard let item = item as? OutlineTreeNodeRef else {
            fatalError("unexpected item type")
        }

        return item.children.count > 0
    }

    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        guard let item = item as? OutlineTreeNodeRef else {
            fatalError("unexpected item type")
        }

        return !item.isGroup
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        let row = outlineView.selectedRow

        guard let item = outlineView.item(atRow: row) as? OutlineTreeNodeRef,
              !item.isGroup else {
            return
        }

        onSelectionChange(item.indexPath)
    }
}
