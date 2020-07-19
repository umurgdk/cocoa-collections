//
//  ViewController.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/11.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit
import OutlineView

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

extension TweetUser: OutlineTreeNode {
    var numberOfChildren: Int { popular.count }
    var children: [String] { popular }
    func child(at index: Int) -> String? { popular[index] }
}

extension Tweet: OutlineTreeNode {
    var numberOfChildren: Int { followers.count }
    var children: [TweetUser] { followers }
    func child(at index: Int) -> TweetUser? { followers[index] }
}

struct TweetViewBuilder: OutlineViewBuilder {
    func build(_ tweet: Tweet, for outlineView: NSOutlineView) -> NSTableCellView {
        let cell = TweetCell()
        cell.configure(with: tweet)
        return cell
    }
}

class ViewController: NSViewController {
    let dataSource = ["Item 1", "Item 2", "Item 3"]
    
    let fileTypes = [
        "Image",
        "Audio",
        "Video"
    ]
    
    let folders: [Tree] = [
        .group("Music", children: [
            "Metal",
            "Electronic",
        ]),
        
        .group("Photos", children: [
            "Izmir",
            "Tokyo",
            "Seoul",
            .group("Portraits", children: [
                "Eren",
                "Umur",
                "Sevgi"
            ])
        ])
    ]
    
    let tweets: [Tweet] = [
        .init(author: "umurgdk", thumbnailURL: URL(string: "https://pbs.twimg.com/profile_images/1279021670276136960/F9Zbh37v_200x200.jpg")!, followers: [
            TweetUser(name: "eren_erinanc", popular: ["1", "2", "3"]),
            TweetUser(name: "twostraws", popular: ["4", "5"]),
            TweetUser(name: "narsimelus", popular: ["some", "tweet"]),
        ]),
        
        .init(author: "eevee", thumbnailURL: URL(string: "https://pbs.twimg.com/profile_images/1070456634118307840/s8TJXv02_200x200.jpg")!, followers: [
            TweetUser(name: "UrsulaColon15", popular: ["a", "b", "c"]),
            TweetUser(name: "viveks3th", popular: ["another", "tweet"])
        ])
    ]
    
    var listView: ListView<TextCell, [String]>!
    var outlineView: OutlineView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        listView = ListView(dataSource: dataSource) { [weak self] cell, index in
            guard let self = self else { return }
            cell.configure(with: self.dataSource[index])
        }
        listView.onSelectionChange = { index in
            if let index = index {
                print("selected item at: \(index)")
            } else {
                print("cleared selection")
            }
        }
        
        let tweetsViewBuilder =
            TweetViewBuilder()
                .withChild(StringViewBuilder.map(\.name)
                    .withChild(StringViewBuilder()))
        outlineView = OutlineView()
        outlineView.addSection(
            "Tweets",
            nodes: tweets,
            viewBuilder: tweetsViewBuilder
        )
        
        outlineView.addSection("Folders", nodes: folders, viewBuilder: StringViewBuilder.map(\.title).recursive())

        outlineView.onSelectionChange = {
            print("Selected: \($0)")
        }
        
        NSLayoutConstraint.activate([
            outlineView.widthAnchor.constraint(greaterThanOrEqualToConstant: 250),
            outlineView.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            listView.widthAnchor.constraint(greaterThanOrEqualToConstant: 300),
            listView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let splitView = NSSplitView()
        splitView.dividerStyle = .thin
        splitView.isVertical = true

        splitView.addArrangedSubview(outlineView)
        splitView.addArrangedSubview(listView)

        view = splitView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        outlineView.reloadData()
    }
}
