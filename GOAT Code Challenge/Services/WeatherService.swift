//
//  WeatherService.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/9/21.
//

import CoreLocation
import Foundation

protocol WeatherServiceType {
  func fetch(for location: CLLocation, callback: @escaping (([WeatherService.Response]?) -> Void))
}

class WeatherService: WeatherServiceType {
  struct Response: Codable {
    let date: Int
    let high: Decimal
    let low: Decimal
    let icon: String
  }

  #warning("-Type")
  private let urlSession: URLSession
  private let jsonDecoder: JSONDecoder
  init(urlSession: URLSession = URLSession(configuration: .default), jsonDecoder: JSONDecoder = JSONDecoder()) {
    self.urlSession = urlSession
    self.jsonDecoder = jsonDecoder
  }
}

// MARK: - Interface
extension WeatherService {
  func fetch(for location: CLLocation, callback: @escaping (([WeatherService.Response]?) -> Void)) {

    guard let url = self.url(with: location.coordinate)
      else { return callback(nil) }

    urlSession.dataTask(with: url) { [jsonDecoder] data, response, error in
      // Productionization: understand better what the response actually is, if we have more info about the error
      if let data = data.flatMap({ try? jsonDecoder.decode(JSONResponse.self, from: $0) }) {
//        callback(data)
        NSLog("\(data)")
        callback(data.daily.compactMap(WeatherService.Response.init))
      }
    }.resume()
  }
}

// MARK: - Helpers
private extension WeatherService {
  func url(with coordinate: CLLocationCoordinate2D) -> URL? {
    let key = "35d4f3309e9295e7e7278b0725de8e19"

    #warning("test for building this URL")
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
      }

      let dt: Int
      let temp: Temperature
      let weather: [Weather]
    }

    let daily: [Daily]
  }
}

private extension WeatherService.Response {
  init?(from day: WeatherService.JSONResponse.Daily) {
    date = day.dt
    high = day.temp.max
    low = day.temp.min
    // Productionization: handle this nil case better, at least report to remote service
    icon = day.weather.first?.icon ?? ""
  }
}
