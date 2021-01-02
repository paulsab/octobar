//
//  AppDelegate.swift
//  OctoBar
//
//  Created by Paul Sabatino on 1/1/21.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()
       
        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 300)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover

        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        if let button = self.statusBarItem.button {
//            button.image = NSImage(named: "Icon")
            button.title = "OctoBar"
            button.action = #selector(togglePopover(_:))
            
        }
        
        let completion: Int = 0
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveCompletion(_:)), name: .didReceiveCompletion, object: nil)
        
    }

    @objc func togglePopover(_ sender: AnyObject?) {
            if let button = self.statusBarItem.button {
                if self.popover.isShown {
                    self.popover.performClose(sender)
                } else {
                    self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                }
            }
        }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func quit(_ sender: AnyObject?) {
        NSLog("Quit")
        exit(0)
    }

    @objc func onDidReceiveCompletion(_ notification: Notification)
    {
        print("completion percent received.... \(notification.debugDescription)")
        
        if let data = notification.object as? Double
        {
            print("Received complettion \(data)")
            DispatchQueue.main.async {
                self.statusBarItem.button?.title = String(format:"OctoBar: %.0f %%", data)
            }
        }
    }

}

