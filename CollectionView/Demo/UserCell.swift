//
//  UserCell.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/19.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

class UserCell: NSTableCellView, UserInterfaceIdentifiable {
    static let identifier = NSUserInterfaceItemIdentifier(String(describing: UserCell.self))
    
    init() {
        super.init(frame: .zero)
        
        let imageView = NSImageView(image: NSImage(named: NSImage.touchBarUserTemplateName)!)
        let textField = NSTextField(labelWithString: "")
        addSubview(imageView)
        addSubview(textField)
        
        self.imageView = imageView
        self.textField = textField
    }
    
    func configure(with user: String) {
        textField?.stringValue = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
