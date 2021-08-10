//
//  WeatherListViewModel.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/9/21.
//

import Bond
import Foundation

protocol WeatherListViewModelType {
  var days: Observable<[WeatherListViewModel.CellViewModel]> { get }

  func requestLocationPermission()
}

class WeatherListViewModel: WeatherListViewModelType {
  struct CellViewModel {
    let date: String
    let temperature: String
    let iconURL: String
  }

  var days = Observable<[CellViewModel]>([])

  private let locationService: LocationServiceType
  private let weatherService: WeatherServiceType

  private let dateFormatter = DateFormatter()
  private let weekdayFormatter = DateFormatter()

  init(
    locationService: LocationServiceType = LocationService(),
    weatherService: WeatherServiceType = WeatherService()
  ) {
    self.locationService = locationService
    self.weatherService = weatherService

    dateFormatter.dateStyle = .short
    weekdayFormatter.dateFormat = "EEEE"
  }
}

// MARK: - Interface
extension WeatherListViewModel {
  func requestLocationPermission() {
    // This would be much better as a promise chain
    locationService.requestLocationPermission { [weatherService, days, dateFormatter, weekdayFormatter] location in
      weatherService.fetch(for: location) { weather in
        guard let weather = weather
          else { return } // Productionization: Show error to user

        days.value = weather.map {
          CellViewModel(from: $0, with: dateFormatter, weekdayFormatter: weekdayFormatter)
        }
      }
    }
  }
}

// MARK: - Helpers
private extension WeatherListViewModel.CellViewModel {
  init(from day: WeatherService.Response, with dateFormatter: DateFormatter, weekdayFormatter: DateFormatter) {
    let date = Date(timeIntervalSince1970: TimeInterval(day.date))
    let dateString = dateFormatter.string(from: date)
    let dayOfWeek = weekdayFormatter.string(from: date)

    self.date = "\(dayOfWeek), \(dateString)"
    temperature = "High: \(day.high)º, Low: \(day.low)º"
    iconURL = "http://openweathermap.org/img/wn/\(day.icon)@2x.png"
  }
}

//extension Date {
//  func dateString(with formatter: DateFormatter) -> String? {
//    formatter.string(from: self)
//  }
//
//  func dayNumberOfWeek() -> Int? {
//    Calendar.current.dateComponents([.weekday], from: self).weekday
//  }
//}
