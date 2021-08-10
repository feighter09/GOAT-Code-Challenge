//
//  WeatherListViewModelSpec.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/9/21.
//

import CoreLocation
import Nimble
import Quick

@testable import GOAT_Code_Challenge

class WeatherListViewModelSpec: QuickSpec {
  var locationService: MockLocationService!
  var weatherService: MockWeatherService!
}

// MARK: - Tests
extension WeatherListViewModelSpec {
  override func spec() {
    var subject: WeatherListViewModel!
    beforeEach { subject = self.newSubject }
    
    describe("requestLocationPermission()") {
      beforeEach {
        subject.requestLocationPermission()
      }
      
      it("calls locationService.requestLocationPermission") {
        expect(self.locationService.requestLocationPermissionCalled).to(beTrue())
      }
      
      context("when the locationService returns a location") {
        beforeEach {
          self.locationService.requestLocationPermissionCallback?(.northPole)
        }
        
        it("loads the weather data for the returned location") {
          expect(self.weatherService.fetchLocation).to(equal(.northPole))
        }
      }
    }
  }
}

// MARK: - Helpers
private extension WeatherListViewModelSpec {
  var newSubject: WeatherListViewModel {
    locationService = MockLocationService()
    weatherService = MockWeatherService()
    return WeatherListViewModel(locationService: locationService, weatherService: weatherService)
  }
}

extension CLLocation {
  static var northPole = CLLocation(latitude: 0, longitude: 0)
}

// MARK: - Mocks
final class MockLocationService: LocationServiceType {
  var requestLocationPermissionCalled = false
  var requestLocationPermissionCallback: ((CLLocation) -> Void)?
  
  func requestLocationPermission(callback: @escaping (CLLocation) -> Void) {
    requestLocationPermissionCalled = true
    requestLocationPermissionCallback = callback
  }
}

final class MockWeatherService: WeatherServiceType {
  var fetchCalled = false
  var fetchLocation: CLLocation?
  func fetch(for location: CLLocation) {
    fetchCalled = true
    fetchLocation = location
  }
}
