//
//  AppDelegate.swift
//  whatwifi
//
//  Created by Jake Bromberg on 10/24/17.
//  Copyright © 2017 Flat Cap. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var wifiMonitor: WiFiEventMonitor?
        
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = NSMenu()
        statusItem.menu?.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        wifiMonitor = try! WiFiEventMonitor { ssidName in
            DispatchQueue.main.async {
                self.statusItem.button?.title = ssidName
                self.statusItem.button?.needsDisplay = true
            }
        }
    }
}
