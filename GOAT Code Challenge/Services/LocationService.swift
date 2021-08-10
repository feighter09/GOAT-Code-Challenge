//
//  LocationService.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/9/21.
//

import CoreLocation
import Foundation

protocol LocationServiceType {
  func requestLocationPermission(callback: @escaping (CLLocation) -> Void)
}

class LocationService: NSObject, LocationServiceType {

  private var requestLocationCallback: ((CLLocation) -> Void)?

  private let locationManager: CLLocationManagerType

  init(locationManager: CLLocationManagerType = CLLocationManager()) {
    self.locationManager = locationManager
    super.init()
    
    locationManager.delegate = self
  }
}

// MARK: - Interface
extension LocationService {
  func requestLocationPermission(callback: @escaping (CLLocation) -> Void) {
    requestLocationCallback = callback

    if locationManager.authorizationStatus == .authorizedWhenInUse {
      locationManager.requestLocation()
    } else {
      locationManager.requestWhenInUseAuthorization()
    }
  }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let latestLocation = locations.last
      else { return }

    requestLocationCallback?(latestLocation)
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // Productionization: Would log this to external service
    NSLog("Location Error: \(error)")
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if manager.authorizationStatus == .authorizedWhenInUse {
      locationManager.requestLocation()
    }
  }
}

