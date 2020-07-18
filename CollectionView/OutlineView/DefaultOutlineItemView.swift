//
//  DefaultOutlineItemView.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

class DefaultOutlineItemView: NSTableCellView, UserInterfaceIdentifiable {
    static let identifier = NSUserInterfaceItemIdentifier(String(describing: DefaultOutlineItemView.self))
    private let iconView = NSImageView()
    private let titleView = NSTextField(labelWithString: "")

    init() {
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
        NSLayoutConstraint.activate(stackView.filling(superview: self))
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 12),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        iconView.image = nil
        titleView.stringValue = ""
        super.prepareForReuse()
    }

    func configure(with title: String, image: NSImage? = nil) {
        iconView.isHidden = image == nil
        iconView.image = image
        titleView.stringValue = title
    }
}
