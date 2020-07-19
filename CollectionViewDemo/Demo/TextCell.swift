//
//  TextCell.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

class TextCell: NSCollectionViewItem, ListViewCell {
    static let identifier = NSUserInterfaceItemIdentifier(String(describing: TextCell.self))
    
    let textView: NSTextField = NSTextField(labelWithString: "")
    var previousTextWidth: CGFloat = 0
    
    override var isSelected: Bool {
        didSet {
            textView.backgroundColor = isSelected ? .controlAccentColor : .white
            textView.textColor = isSelected ? .white : .labelColor
        }
    }
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        textView.drawsBackground = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        textView.drawsBackground = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.addSubview(textView)
        NSLayoutConstraint.activate(textView.filling(superview: view))
        
        self.view = view
    }
    
    override func prepareForReuse() {
        previousTextWidth = 0
    }
    
    func configure(with string: String) -> Self {
        textView.stringValue = string
        return self
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: NSCollectionViewLayoutAttributes) -> NSCollectionViewLayoutAttributes {
        if layoutAttributes.size.width == previousTextWidth {
            return layoutAttributes
        }
        
        previousTextWidth = layoutAttributes.size.width
        
        textView.preferredMaxLayoutWidth = layoutAttributes.size.width
        let size = textView.sizeThatFits(CGSize(width: layoutAttributes.size.width, height: 1000))
        layoutAttributes.size.height = size.height
        return layoutAttributes
    }
}
