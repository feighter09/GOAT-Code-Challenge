//
//  WeatherListCoordinator.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/9/21.
//

import UIKit

protocol WeatherListCoordinatorType: AnyObject {
  func start() -> UIViewController
  func showDetails(for day: DailyWeather)
}

class WeatherListCoordinator: WeatherListCoordinatorType {
  var navigationController: UINavigationController?
}

// MARK - Interface
extension WeatherListCoordinator {
  func start() -> UIViewController {
    let viewModel = WeatherListViewModel(coordinator: self)
    let weatherListVC = WeatherListViewController(viewModel: viewModel)
    let navigationController = UINavigationController(rootViewController: weatherListVC)
    self.navigationController = navigationController
    return navigationController
  }

  func showDetails(for weather: DailyWeather) {
    let viewModel = WeatherDetailsViewModel(dailyWeather: weather)
    let detailsVC = WeatherDetailsViewController(viewModel: viewModel)
    navigationController?.pushViewController(detailsVC, animated: true)
  }
}

