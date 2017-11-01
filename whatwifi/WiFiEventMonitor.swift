//
//  WiFiEventMonitor.swift
//  whatwifi
//
//  Created by Jake Bromberg on 11/1/17.
//  Copyright © 2017 Flat Cap. All rights reserved.
//

import CoreWLAN


public final class WiFiEventMonitor {
    /// The callback invoked when the SSID name changes.
    public typealias UpdateSSID = (String) -> ()

    private let wifiClient: CWWiFiClient
    private let update: UpdateSSID

    public init(wifiClient: CWWiFiClient = .shared(), updater: @escaping UpdateSSID) throws {
        self.update = updater
        
        self.wifiClient = wifiClient
        self.wifiClient.delegate = self
        try self.wifiClient.startMonitoringEvent(with: .ssidDidChange)
        
        // This is a hack. There's something odd with the runtime where the delegate won't fire this callback unless
        // manually invoked first.
        ssidDidChangeForWiFiInterface(withName: "")
    }
}

extension WiFiEventMonitor: CWEventDelegate {
    public func ssidDidChangeForWiFiInterface(withName interfaceName: String) {
        let name = CWWiFiClient.shared().interface()?.ssid() ?? "Disconnected"
        update(name)
    }
}
