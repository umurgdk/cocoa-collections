//
//  UserCell.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/19.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

class UserCell: NSTableCellView {
    static let identifier = NSUserInterfaceItemIdentifier(String(describing: UserCell.self))
    
    init() {
        super.init(frame: .zero)
        
        let imageView = NSImageView(image: NSImage(named: NSImage.touchBarUserTemplateName)!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let textField = NSTextField(labelWithString: "")
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = NSStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.orientation = .horizontal
        stackView.spacing = 8
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textField)
        
        addSubview(stackView)
        
        self.imageView = imageView
        self.textField = textField
        
        NSLayoutConstraint.activate(stackView.filling(superview: self))
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 12),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    func configure(with user: String) {
        textField?.stringValue = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
