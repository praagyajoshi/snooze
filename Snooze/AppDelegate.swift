//
//  AppDelegate.swift
//  Snooze
//
//  Created by Praagya Joshi on 03/04/18.
//  Copyright © 2018 Praagya Joshi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Setup the icon
        if let button = statusItem.button {
            let icon = NSImage.init(named: NSImage.Name("StatusBarButtonImage"))
            icon?.isTemplate = true
            button.image = icon
            button.action = #selector(self.togglePopover(_:))
        }
        
        // Setup the view controller for popover
        popover.appearance = NSAppearance.init(named: NSAppearance.Name.vibrantLight)
        popover.contentViewController = PopoverViewController()
        
        // Setup the event monitor
        eventMonitor = EventMonitor.init(mask: [.leftMouseDown, .rightMouseDown], handler: { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        })
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // MARK: Popover methods
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            self.closePopover(sender: sender)
        } else {
            self.showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }

}

