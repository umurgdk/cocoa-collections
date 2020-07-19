//
//  Tree.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/19.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import Foundation
import OutlineView
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
