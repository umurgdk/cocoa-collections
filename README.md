#  Cocoa Collections

Type safe collection view wrappers for AppKit.

## OutlineView

NOTE: OutlineView implementation contains it's own ScrollView. This might change in the future.

### Custom data structure example, each nested structure's type is different

```swift
import OutlineView

struct Tweet {
    let author: String
    let thumbnailURL: URL
    let followers: [TweetUser]
}

struct TweetUser {
    let name: String
    let popular: [String]
}

// Conform your types to OutlineTreeNode, so OutlineView can show them as tree 
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

// OutlineViewBuilders are used for building custom row views with
// strongly typed data item. Data item's type must match OutlineTreeNode conforming type's children
struct TweetViewBuilder: OutlineViewBuilder {
    func build(_ tweet: Tweet, for outlineView: NSOutlineView) -> NSTableCellView {
        let cell = TweetCell()
        cell.configure(with: tweet)
        return cell
    }
}

class ExampleViewController: NSViewController {
    var outlineView: OutlineView!

    // Some sample data to show nested data structures. You can use simple structs for your
    // data, no need to subclass.
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

    func loadView() {
        outlineView = OutlineView()
    
        // Let's build a OutlineViewBuilder tree to match our nested data structure, each nested level of our data
        // structure can have its own custom views
        let tweetsViewBuilder =
            TweetViewBuilder()
                .withChild(StringViewBuilder.map(\.name)   // Handy view builder for text only rows with custom types
                    .withChild(StringViewBuilder()))       // Handy view builder for text only rows where data matches String
                    
        // Our view builder tree enforce a nested type structure so our data (which implements OutlineTreeNode)
        // should match view builder's type tree otherwise we got a compile time error! Sections maps to NSOutlineView's
        // groups.
        outlineView.addSection(
            "Tweets",
            nodes: tweets,
            viewBuilder: tweetsViewBuilder
        )
    }
}
```

### Custom data structure example, each nested structure's type is same (for example file system tree), a recursive data type

```swift
import OutlineView

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

class ExampleViewController: NSViewController {
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
    
    func loadView() {
        let outlineView = OutlineView()
        let viewBuilder = StringViewBuilder.map(\.title)    // map each tree node to it's title (String)
            .recursive()                                    // recursive modifier allows Tree like structs to have
                                                            // indefinite number of levels
            
        outlineView.addSection("Folders", nodes: folders, viewBuilder: viewBuilder)
    }
}
```
