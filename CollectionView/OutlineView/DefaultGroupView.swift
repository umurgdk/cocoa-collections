//
//  OutlineGroupView.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

extension NSView {
    func filling(superview: NSView) -> [NSLayoutConstraint] {
        [
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor)
        ]
    }
}

class DefaultOutlineGroupView: NSTableCellView, UserInterfaceIdentifiable {
    static let identifier = NSUserInterfaceItemIdentifier(String(describing: DefaultOutlineGroupView.self))
    private let titleView = NSTextField(labelWithString: "")

    init() {
        super.init(frame: .zero)

        textField = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleView)

        NSLayoutConstraint.activate(titleView.filling(superview: self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        titleView.stringValue = ""
        super.prepareForReuse()
    }

    func configure(with title: String) {
        titleView.stringValue = title
    }
}
