//
//  TweetCell.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/18.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

class TweetCell: NSTableCellView, UserInterfaceIdentifiable {
    static let identifier = NSUserInterfaceItemIdentifier(String(describing: TweetCell.self))
    
    let thumbnailView = NSImageView()
    let likesView = NSTextField(labelWithString: "")
    let authorView = NSTextField(labelWithString: "")
    
    init() {
        super.init(frame: .zero)
        
        authorView.lineBreakMode = .byTruncatingTail
        authorView.maximumNumberOfLines = 1
        
        // NSOutlineView applies some styling to these items
        textField = authorView
        imageView = thumbnailView
        
        let stack = NSStackView(views: [thumbnailView, authorView, likesView])
        stack.orientation = .horizontal
        stack.spacing = 8
        addSubview(stack)
        
        authorView.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        NSLayoutConstraint.activate([
            authorView.topAnchor.constraint(equalTo: topAnchor),
            authorView.leftAnchor.constraint(equalTo: leftAnchor),
            authorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            authorView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cofigure(with tweet: Tweet) {
        thumbnailView.image = NSImage(contentsOf: tweet.thumbnailURL)
        likesView.stringValue = "LIKES: \(tweet.likes)"
        authorView.stringValue = "@\(tweet.author)"
    }
}
