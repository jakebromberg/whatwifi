//
//  WiFiEventMonitor.swift
//  whatwifi
//
//  Created by Jake Bromberg on 11/1/17.
//  Copyright © 2017 Flat Cap. All rights reserved.
//

import CoreWLAN
import CoreLocation

public final class WiFiEventMonitor: NSObject {
    /// The callback invoked when the SSID name changes.
    public typealias SSIDUpdate = (String) -> ()

    private let wifiClient: CWWiFiClient
    private let locationManager = CLLocationManager()
    private let update: SSIDUpdate

    public init(wifiClient: CWWiFiClient = .shared(), updater: @escaping SSIDUpdate) throws {
        self.update = updater
        
        self.wifiClient = wifiClient
        
        super.init()
        
        self.wifiClient.delegate = self
        
        self.locationManager.delegate = self
        
        // This is a hack. There's something odd with the runtime where the delegate won't fire this callback unless
        // manually invoked first.
        ssidDidChangeForWiFiInterface(withName: "")
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            return
        case .denied:
            return
        case .authorizedAlways:
            return
        @unknown default:
            return
        }
    }
}

extension WiFiEventMonitor: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return
        case .restricted:
            return
        case .denied:
            return
        case .authorizedAlways:
            try! self.wifiClient.startMonitoringEvent(with: .ssidDidChange)
            return
        @unknown default:
            return
        }
    }
}

extension WiFiEventMonitor: CWEventDelegate {
    public func ssidDidChangeForWiFiInterface(withName interfaceName: String) {
        let name = CWWiFiClient.shared().interface()?.ssid() ?? "Disconnected"
        update(name)
    }
}
