//
//  ListView.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

protocol ListViewCell: NSCollectionViewItem {
    static var identifier: NSUserInterfaceItemIdentifier { get }
}

protocol ListViewDataSource {
    var numberOfItems: Int { get }
}

class FlippedClipView: NSClipView {
    override var isFlipped: Bool {true}
}

class ListView<Cell, DataSource>: NSView, NSCollectionViewDataSource, NSCollectionViewDelegate, ListCollectionViewKeyboardDelegate
    where Cell: ListViewCell, DataSource: ListViewDataSource
{
    private let collectionView = ListCollectionView()
    private let scrollView = NSScrollView()
    
    var onSelectionChange: ((Int?) -> Void)?
    let buildCell: (Cell, Int) -> Void
    let dataSource: DataSource
    
    var isSelectable: Bool {
        get { collectionView.isSelectable }
        set { collectionView.isSelectable = newValue }
    }
    
    init(dataSource: DataSource, buildCell: @escaping (Cell, Int) -> Void) {
        self.buildCell = buildCell
        self.dataSource = dataSource
        super.init(frame: .zero)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.collectionViewLayout = ListViewLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.keyboardDelegate = self
        collectionView.isSelectable = true

        scrollView.documentView = collectionView
        scrollView.hasHorizontalScroller = false
        scrollView.borderType = .noBorder
        addSubview(scrollView)
        
        collectionView.register(Cell.self, forItemWithIdentifier: Cell.identifier)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - First Responder
    func navigateWith(arrowKey: ArrowKey) {
        guard let selection = collectionView.selectionIndexes.first else {
            collectionView.selectItems(at: [IndexPath(item: 0, section: 0)], scrollPosition: .top)
            return
        }
        
        let lastItemIndex = max(0, collectionView.numberOfItems(inSection: 0) - 1)
        
        switch arrowKey {
        case .up:
            let index = max(0, selection - 1)
            collectionView.deselectAll(nil)
            collectionView.selectItems(at: [IndexPath(item: index, section: 0)], scrollPosition: .top)
            onSelectionChange?(index)
        case .down:
            let index = min(selection + 1, lastItemIndex)
            collectionView.deselectAll(nil)
            collectionView.selectItems(at: [IndexPath(item: index, section: 0)], scrollPosition:
                .bottom)
            onSelectionChange?(index)
        default:
            break
        }
    }
    
    // MARK: - NSCollectionViewDataSource
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.numberOfItems
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = collectionView.makeItem(withIdentifier: Cell.identifier, for: indexPath) as? Cell else {
            fatalError("ListView couldn't make an item for identifier: \(Cell.identifier)")
        }
        
        buildCell(cell, indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        onSelectionChange?(indexPaths.first?.item)
    }
}

extension Array: ListViewDataSource {
    var numberOfItems: Int {
        count
    }
}
