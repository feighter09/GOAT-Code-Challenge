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
  func showDetails(for index: Int)
}

class WeatherListViewModel: WeatherListViewModelType {
  struct CellViewModel {
    let date: String
    let temperature: String
    let iconURL: URL?
  }

  let days = Observable<[CellViewModel]>([])
  private let dailyWeather = Observable<[DailyWeather]>([])

  private let locationService: LocationServiceType
  private let weatherService: WeatherServiceType
  private weak var coordinator: WeatherListCoordinatorType?

  private let dateFormatter = DateFormatter()
  private let weekdayFormatter = DateFormatter()

  init(
    locationService: LocationServiceType = LocationService(),
    weatherService: WeatherServiceType = WeatherService(),
    coordinator: WeatherListCoordinatorType
  ) {
    self.locationService = locationService
    self.weatherService = weatherService
    self.coordinator = coordinator

    bindDataToCellViewModels()
  }
}

// MARK: - Interface
extension WeatherListViewModel {
  func requestLocationPermission() {
    // This would be much better as a promise chain
    locationService.requestLocationPermission { [weatherService, dailyWeather] location in
      weatherService.fetch(for: location) { weather in
        guard let weather = weather
          else { return } // Productionization: Show error to user

        dailyWeather.value = weather
      }
    }
  }

  func showDetails(for index: Int) {
    guard let weather = dailyWeather.value[safe: index]
      else { return } // Productionization: handle index not found better, at least report an error

    coordinator?.showDetails(for: weather)
  }
}

// MARK: - Helpers
private extension WeatherListViewModel {
  func bindDataToCellViewModels() {
    dateFormatter.dateStyle = .short
    weekdayFormatter.dateFormat = "EEEE"

    dailyWeather.map({ [dateFormatter, weekdayFormatter] in
      $0.map { CellViewModel(from: $0, with: dateFormatter, weekdayFormatter: weekdayFormatter) }
    }).bind(to: days)
  }
}

private extension WeatherListViewModel.CellViewModel {
  init(
    from day: DailyWeather,
    with dateFormatter: DateFormatter,
    weekdayFormatter: DateFormatter
  ) {
    let date = Date(timeIntervalSince1970: TimeInterval(day.date))
    let dateString = dateFormatter.string(from: date)
    let dayOfWeek = weekdayFormatter.string(from: date)

    self.date = "\(dayOfWeek), \(dateString)"
    temperature = "High: \(day.high.rounded)º, Low: \(day.low.rounded)º"
    iconURL = URL(string: "https://openweathermap.org/img/wn/\(day.icon)@2x.png")
  }
}

private extension Decimal {
  var rounded: Int {
    Int(NSDecimalNumber(decimal: self).doubleValue.rounded())
  }
}
