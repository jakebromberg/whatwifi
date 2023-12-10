//
//  LocationManager.swift
//  whatwifi
//
//  Created by Jake Bromberg on 9/30/23.
//  Copyright © 2023 Flat Cap. All rights reserved.
//

import Foundation
import CoreLocation

class LocationDataManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func startLocationServices(completion: @escaping () -> (Bool)) {
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
    
    // Location-related properties and delegate methods.
}
