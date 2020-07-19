//
//  TweetCell.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/18.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

class TweetCell: NSTableCellView {
    static let identifier = NSUserInterfaceItemIdentifier(String(describing: TweetCell.self))
    
    let thumbnailView = NSImageView()
    let followersView = NSTextField(labelWithString: "")
    let authorView = NSTextField(labelWithString: "")
    
    init() {
        super.init(frame: .zero)
        
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        authorView.translatesAutoresizingMaskIntoConstraints = false
        followersView.translatesAutoresizingMaskIntoConstraints = false
        
        authorView.lineBreakMode = .byTruncatingTail
        authorView.maximumNumberOfLines = 1
        
        followersView.lineBreakMode = .byTruncatingMiddle
        
        // NSOutlineView applies some styling to these items
        textField = authorView
        imageView = thumbnailView
        
        let badgeView = NSView()
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = NSStackView(views: [thumbnailView, authorView, followersView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .horizontal
        stack.spacing = 8
        addSubview(stack)
        
        authorView.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        followersView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        thumbnailView.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        NSLayoutConstraint.activate([
            thumbnailView.widthAnchor.constraint(equalToConstant: 12),
            thumbnailView.heightAnchor.constraint(equalTo: thumbnailView.widthAnchor),
        ])
        NSLayoutConstraint.activate(stack.filling(superview: self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tweet: Tweet) {
        thumbnailView.image = NSImage(contentsOf: tweet.thumbnailURL)
        followersView.stringValue = "FOLLOWERS: \(tweet.followers.count)"
        authorView.stringValue = "@\(tweet.author)"
    }
}
