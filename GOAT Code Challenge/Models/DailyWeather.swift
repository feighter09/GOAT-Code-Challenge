//
//  DailyWeather.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/10/21.
//

import Foundation

struct DailyWeather: Codable {
  let date: Int
  let high: Decimal
  let low: Decimal
  let icon: String
  let description: String
}
