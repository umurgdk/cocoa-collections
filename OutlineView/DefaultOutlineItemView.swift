//
//  DefaultOutlineItemView.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

public struct OutlineItemViewBuilder<Item>: OutlineViewBuilder {
    public let builder: (Item, DefaultOutlineItemView) -> Void
    public func build(_ item: Item, for outlineView: NSOutlineView) -> NSTableCellView {
        let cell = DefaultOutlineItemView()
        builder(item, cell)
        return cell
    }
}

public class DefaultOutlineItemView: NSTableCellView {
    static let identifier = NSUserInterfaceItemIdentifier(String(describing: DefaultOutlineItemView.self))
    private let iconView = NSImageView()
    private let titleView = NSTextField(labelWithString: "")

    public init() {
        super.init(frame: .zero)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleView.translatesAutoresizingMaskIntoConstraints = false

        textField = titleView
        imageView = iconView
        
        let stackView = NSStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.orientation = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(iconView)
        stackView.addArrangedSubview(titleView)

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            iconView.widthAnchor.constraint(equalToConstant: 12),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepareForReuse() {
        iconView.image = nil
        titleView.stringValue = ""
        super.prepareForReuse()
    }

    public func configure(with title: String, image: NSImage? = nil) {
        iconView.isHidden = image == nil
        iconView.image = image
        titleView.stringValue = title
    }
}
