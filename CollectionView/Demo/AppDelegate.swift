//
//  AppDelegate.swift
//  CollectionView
//
//  Created by Umur Gedik on 2020/07/11.
//  Copyright © 2020 Umur Gedik. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var windowController: NSWindowController!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let window = NSWindow(contentViewController: ViewController())
        window.styleMask.insert(.resizable)
        window.titleVisibility = .hidden

        windowController = NSWindowController(window: window)
        windowController.contentViewController = window.contentViewController
        windowController.showWindow(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

