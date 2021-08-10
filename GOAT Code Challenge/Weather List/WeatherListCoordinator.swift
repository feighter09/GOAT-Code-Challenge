//
//  WeatherListCoordinator.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/9/21.
//

import UIKit

protocol WeatherListCoordinatorType {
  func start() -> UIViewController
}

class WeatherListCoordinator: WeatherListCoordinatorType {}

// MARK - Interface
extension WeatherListCoordinator {
  func start() -> UIViewController {
    return UINavigationController(rootViewController: WeatherListViewController())
  }
}

