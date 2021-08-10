//
//  LocationServiceSpec.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/9/21.
//

import CoreLocation
import Nimble
import Quick

@testable import GOAT_Code_Challenge

class LocationServiceSpec: QuickSpec {
  var locationManager: MockLocationManager!
}

// MARK: - Tests
extension LocationServiceSpec {
  override func spec() {
    var subject: LocationService!
    beforeEach { subject = self.newSubject }

    describe("requestLocationPermission(callback:)") {
      beforeEach {
        subject.requestLocationPermission(callback: {_ in})
      }

      it("calls locationManager.requestLocation()") {
        XCTFail("not written")
      }

      context("when locationManager updates the location") {
        it("calls the callback with that location") {
          XCTFail("not written")
        }
      }
    }
  }
}

// MARK: - Helpers
private extension LocationServiceSpec {
  var newSubject: LocationService {
    locationManager = MockLocationManager()
    return LocationService(locationManager: locationManager)
  }
}

// MARK: - Mocks
final class MockLocationManager: CLLocationManagerType {
  var delegate: CLLocationManagerDelegate?

  var requestLocationCalled = false
  func requestLocation() { requestLocationCalled = true }
}
