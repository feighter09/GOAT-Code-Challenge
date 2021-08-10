//
//  WeatherService.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/9/21.
//

import CoreLocation
import Foundation

protocol WeatherServiceType {
  func fetch(for location: CLLocation, callback: @escaping (([DailyWeather]?) -> Void))
}

class WeatherService: WeatherServiceType {
  private let urlSession: URLSession
  private let jsonDecoder: JSONDecoder
  init(urlSession: URLSession = URLSession(configuration: .default), jsonDecoder: JSONDecoder = JSONDecoder()) {
    self.urlSession = urlSession
    self.jsonDecoder = jsonDecoder
  }
}

// MARK: - Interface
extension WeatherService {
  func fetch(for location: CLLocation, callback: @escaping (([DailyWeather]?) -> Void)) {

    guard let url = self.url(with: location.coordinate)
      else { return callback(nil) }

    urlSession.dataTask(with: url) { [jsonDecoder] data, response, error in
      // Productionization: understand better what the response actually is, if we have more info about the error
      if let data = data.flatMap({ try? jsonDecoder.decode(JSONResponse.self, from: $0) }) {
        let response = data.daily.compactMap(DailyWeather.init)
        callback(response)
      }
    }.resume()
  }
}

// MARK: - Helpers
private extension WeatherService {
  func url(with coordinate: CLLocationCoordinate2D) -> URL? {
    // Productionization: put this somewhere safer
    let key = "35d4f3309e9295e7e7278b0725de8e19"

    let url = "https://api.openweathermap.org/data/2.5/onecall?"
      + "lat=\(coordinate.latitude)"
      + "&lon=\(coordinate.longitude)"
      + "&exclude=minutely,hourly,alerts"
      + "&appid=\(key)"

    return URL(string: url)
  }

  struct JSONResponse: Codable {
    struct Daily: Codable {
      struct Temperature: Codable {
        let min: Decimal
        let max: Decimal
      }
      struct Weather: Codable {
        let icon: String
        let description: String
      }

      let dt: Int
      let temp: Temperature
      let weather: [Weather]
    }

    let daily: [Daily]
  }
}

private extension DailyWeather {
  init?(from day: WeatherService.JSONResponse.Daily) {
    date = day.dt
    high = day.temp.max
    low = day.temp.min
    // Productionization: handle this nil case better, at least report to remote service
    icon = day.weather.first?.icon ?? ""
    description = day.weather.first?.description ?? ""
  }
}
