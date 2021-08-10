//
//  CLLocationManagerType.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/9/21.
//

import CoreLocation
import Foundation

protocol CLLocationManagerType: AnyObject {
  var authorizationStatus: CLAuthorizationStatus { get }
  var delegate: CLLocationManagerDelegate? { get set }

  func requestWhenInUseAuthorization()
  func requestLocation()
}

extension CLLocationManager: CLLocationManagerType {}
