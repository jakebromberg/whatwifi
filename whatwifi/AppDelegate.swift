//
//  AppDelegate.swift
//  wifiname
//
//  Created by Jake Bromberg on 10/24/17.
//  Copyright © 2017 Flat Cap. All rights reserved.
//

import Cocoa
import CoreWLAN

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let wifiClient = CWWiFiClient.shared()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.menu = NSMenu()
        statusItem.menu?.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.length = NSStatusItem.variableLength
        
        updateTitle()
        
        wifiClient.delegate = self
        try! wifiClient.startMonitoringEvent(with: .ssidDidChange)
    }
    
    func updateTitle() {
        guard let name = CWWiFiClient.shared().interface()?.ssid() else {
            return
        }
        
        DispatchQueue.main.async {
            self.statusItem.button?.title = name
            self.statusItem.button?.setNeedsDisplay()
        }
    }
}

extension AppDelegate: CWEventDelegate {
    func ssidDidChangeForWiFiInterface(withName interfaceName: String) {
        updateTitle()
    }
}
