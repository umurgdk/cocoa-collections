//
//  OutlineItemBuilder.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

// TODO: Is it possible to have indirect `structs` instead of enums? It is a bit messy with enums.
indirect enum OutlineViewBuilder<Item: OutlineTreeNode>
{
    typealias ViewID = NSUserInterfaceItemIdentifier
    case customChild(viewID: ViewID, childBuilder: OutlineViewBuilder<Item.Child>, build: (NSOutlineView, Item) -> NSTableCellView)
    case sameChild(viewID: ViewID, build: (NSOutlineView, Item) -> NSTableCellView)

    var viewIdentifier: ViewID {
        switch self {
        case let .customChild(viewID, _, _), let .sameChild(viewID, _):
            return viewID
        }
    }
    
    var childBuilder: OutlineViewBuilder<Item.Child> {
        switch self {
        case let .customChild(_, childBuilder, _):
            return childBuilder
        case .sameChild:
            return self as! OutlineViewBuilder<Item.Child>
        }
    }
    
    func build(outlineView: NSOutlineView, item: Item) -> NSTableCellView {
        switch self {
        case let .sameChild(_, build), let .customChild(_, _, build):
            return build(outlineView, item)
        }
    }
    
    init<ItemView>(build: @escaping (ItemView?, Item) -> ItemView)
        where
        ItemView: NSTableCellView,
        ItemView: UserInterfaceIdentifiable
    {
        self = .sameChild(viewID: ItemView.identifier) { outlineView, item in
            let view = outlineView.makeView(withIdentifier: ItemView.identifier, owner: outlineView) as? ItemView
            return build(view, item)
        }
    }
    
    init<ItemView>(build: @escaping (ItemView?, Item) -> ItemView,
                    childBuilder: OutlineViewBuilder<Item.Child>)
        where ItemView: NSTableCellView,
              ItemView: UserInterfaceIdentifiable
    {
        self = .customChild(viewID: ItemView.identifier, childBuilder: childBuilder) { outlineView, item in
            let view = outlineView.makeView(withIdentifier: ItemView.identifier, owner: outlineView) as? ItemView
            return build(view, item)
        }
    }
}

extension OutlineViewBuilder {
    static func `default`(groupView buildGroupView: @escaping (DefaultOutlineGroupView, Item) -> Void, itemView buildItemView: @escaping (DefaultOutlineItemView, Item.Child) -> Void) -> Self {
        let childBuilder = OutlineViewBuilder<Item.Child>.sameChild(viewID: DefaultOutlineItemView.identifier) { outlineView, item in
            let view = outlineView.makeView(withIdentifier: DefaultOutlineItemView.identifier, owner: outlineView) as? DefaultOutlineItemView ?? DefaultOutlineItemView()
            buildItemView(view, item)
            return view
        }
        
        return OutlineViewBuilder.customChild(viewID: DefaultOutlineGroupView.identifier, childBuilder: childBuilder) { outlineView, item in
            let view = outlineView.makeView(withIdentifier: DefaultOutlineGroupView.identifier, owner: outlineView) as? DefaultOutlineGroupView ?? DefaultOutlineGroupView()
            buildGroupView(view, item)
            return view
        }
    }
}
