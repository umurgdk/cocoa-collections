//
//  ViewController.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/11.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

enum Tree: OutlineTreeNode {
    case group(String, children: [Tree])
    case leaf(String)

    var title: String {
        switch self {
        case let .group(title, _), let .leaf(title):
            return title
        }
    }
    
    var numberOfChildren: Int {
        if case let .group(_, children) = self {
            return children.count
        }
        
        return 0
    }
    
    var children: [Tree] {
        if case let .group(_, children) = self {
            return children
        }
        
        return []
    }
    
    func child(at index: Int) -> Tree? {
        if case let .group(_, children) = self {
            return children[index]
        }
        
        return nil
    }
}

extension Tree: ExpressibleByStringLiteral {
    init(stringLiteral value: StringLiteralType) {
        self = .leaf(value)
    }
}

struct UserNode: OutlineTreeNode {    
    typealias Child = Never
    
    let user: String
    var numberOfChildren: Int { 0 }
    var children: [Child]
    func child(at index: Int) -> Child? {
        return nil
    }
}

struct TweetNode: OutlineTreeNode {
    let tweet: Tweet
    
    var numberOfChildren: Int { tweet.mentions.count }
    var children: [UserNode] { tweet.mentions.lazy.map(UserNode) }
    func child(at index: Int) -> UserNode? { UserNode(user: tweet.mentions[index]) }
}

struct TweetSection: OutlineTreeNode {
    let title: String
    let tweets: [Tweet]
    
    var children: [Child] { tweets }
    var numberOfChildren: Int { tweets.count }
    func child(at index: Int) -> Tweet? {
        tweets[index]
    }
}

class ViewController: NSViewController {
    let dataSource = ["Item 1", "Item 2", "Item 3"]
    let sourceList: [Tree] = [
        .group("File Types", children: [
            "Image",
            "Audio",
            "Video"
        ]),
        
        .group("Folders", children: [
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
        ])
    ]
    
    var listView: ListView<TextCell, [String]>!
    var outlineView: OutlineView<Tree>!
    
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
        
        outlineView = OutlineView(
            rootNodes: sourceList,
            viewBuilder: .default(
                groupView: { view, item in
                    view.configure(with: item.title)
                },
                itemView: { view, item in
                    let image = item.numberOfChildren > 0 ? NSImage(named: NSImage.folderName) : nil
                    view.configure(with: item.title, image: image)
                }
            )
        )

        outlineView.onSelectionChange = { [weak self] indexPath in
            guard let item = self?.sourceList.child(at: indexPath) else {
                print("deselected")
                return
            }

            print("Selected: \(item.title)")
        }
        
        NSLayoutConstraint.activate([
            outlineView.widthAnchor.constraint(equalToConstant: 200),
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
        outlineView.outlineView.reloadData()
    }
}
