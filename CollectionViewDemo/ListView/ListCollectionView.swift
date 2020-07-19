//
//  ListCollectionView.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/17.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import AppKit

enum ArrowKey {
    case up, down, left, right
}

extension NSEvent {
    static let arrowKeyCodes: [Int: ArrowKey] = [
        NSUpArrowFunctionKey:    .up,
        NSDownArrowFunctionKey:  .down,
        NSLeftArrowFunctionKey:  .left,
        NSRightArrowFunctionKey: .right
    ]
    
    var arrowKey: ArrowKey? {
        guard let keyCode = charactersIgnoringModifiers?.utf16.first,
              let arrowKey = Self.arrowKeyCodes[Int(keyCode)]
            else {
                return nil
        }
        
        return arrowKey
    }
}

protocol ListCollectionViewKeyboardDelegate: class {
    func navigateWith(arrowKey: ArrowKey)
}

class ListCollectionView: NSCollectionView {
    weak var keyboardDelegate: ListCollectionViewKeyboardDelegate?
    
    override func keyDown(with event: NSEvent) {
        guard let keyboardDelegate = keyboardDelegate,
            let arrowKey = event.arrowKey else {
            return super.keyDown(with: event)
        }
        
        keyboardDelegate.navigateWith(arrowKey: arrowKey)
    }
}
