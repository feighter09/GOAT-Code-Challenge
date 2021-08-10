//
//  WeatherDetailsViewModel.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/10/21.
//

import Foundation

struct WeatherDetailsViewModel {
  let title: String
  let description: String

  init(dailyWeather: DailyWeather) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    let date = Date(timeIntervalSince1970: TimeInterval(dailyWeather.date))

    title = dateFormatter.string(from: date)
    description = "Description: \(dailyWeather.description)"
  }
}
