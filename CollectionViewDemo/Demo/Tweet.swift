//
//  Tweet.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/19.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import Foundation

struct Tweet {
    let author: String
    let thumbnailURL: URL
    let followers: [TweetUser]
}

struct TweetUser {
    let name: String
    let popular: [String]
}
