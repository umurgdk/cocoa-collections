//
//  OutlineGroupView.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

struct OutlineGroupHeaderViewBuilder<Child>: OutlineViewBuilder {
    public func build(_ item: OutlineSection<Child>, for outlineView: NSOutlineView) -> NSTableCellView {
        let cell = DefaultOutlineGroupView()
        cell.configure(with: item.title)
        return cell
    }
}

public class DefaultOutlineGroupView: NSTableCellView {
    static let identifier = NSUserInterfaceItemIdentifier(String(describing: DefaultOutlineGroupView.self))
    private let titleView = NSTextField(labelWithString: "")

    init() {
        super.init(frame: .zero)

        textField = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleView)

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topAnchor),
            titleView.leftAnchor.constraint(equalTo: leftAnchor),
            titleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public  func prepareForReuse() {
        titleView.stringValue = ""
        super.prepareForReuse()
    }

    public func configure(with title: String) {
        titleView.stringValue = title
    }
}
