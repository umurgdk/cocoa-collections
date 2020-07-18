//
//  ListViewLayout.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/11.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

class ListViewLayout: NSCollectionViewLayout {
    private var items = [IndexPath: NSCollectionViewLayoutAttributes]()
    private var preferredItemAttributes = [IndexPath: NSCollectionViewLayoutAttributes]()
    private lazy var boundsWidth: CGFloat = {
        collectionView?.bounds.width ?? 0
    }()
    
    override var collectionViewContentSize: NSSize {
        let maxY = items.values.max { $0.frame.maxY < $1.frame.maxY }?.frame.maxY ?? 100
        let size = NSSize(width: boundsWidth, height: maxY)
        return size
    }
    
    override func prepare() {
        guard
            let collectionView = collectionView,
            let dataSource = collectionView.dataSource else { return }
            
        items = [:]
        let numItems = dataSource.collectionView(collectionView, numberOfItemsInSection: 0)
        items.reserveCapacity(numItems)
        
        let width = boundsWidth
        var lastMinY: CGFloat = 0
        
        for i in 0..<numItems {
            let indexPath = IndexPath(item: i, section: 0)
            
            let height: CGFloat = preferredItemAttributes[indexPath]?.size.height ?? 70
            let frame = CGRect(x: 0, y: lastMinY, width: width, height: height)
            let attrs = NSCollectionViewLayoutAttributes(forItemWith: indexPath)
            attrs.frame = frame
            
            items[indexPath] = attrs
            lastMinY += height
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: NSRect) -> Bool {
        if newBounds.width != boundsWidth {
            boundsWidth = newBounds.width
            return true
        }
        
        return false
    }
    
    override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: NSCollectionViewLayoutAttributes, withOriginalAttributes originalAttributes: NSCollectionViewLayoutAttributes) -> Bool {
        if originalAttributes.size.height != preferredAttributes.size.height {
            guard let indexPath = preferredAttributes.indexPath else { return false }
            preferredItemAttributes[indexPath] = preferredAttributes
            return true
        }
        
        return false
    }
    
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        return items.values.filter { rect.intersects($0.frame) }
    }
}
