//
//  WeatherListViewController.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/9/21.
//

import UIKit

class WeatherListViewController: UIViewController {
  private enum Constants {
    static let reuseIdentifier = "cell"
  }

  @IBOutlet private(set) weak var tableView: UITableView!

  private let viewModel: WeatherListViewModelType
  init(viewModel: WeatherListViewModelType = WeatherListViewModel()) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented, use init(viewModel:)") }
}

// MARK - View Life Cycle
extension WeatherListViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setupLocationPermissionButton()
    setupTableView()
  }
}

// MARK: - Helpers
private extension WeatherListViewController {
  func setupLocationPermissionButton() {
    let allowLocationButton = UIBarButtonItem(
      title: "Allow Location",
      style: .plain,
      target: self,
      action: #selector(requestLocation)
    )
    navigationItem.rightBarButtonItem = allowLocationButton
  }

  func setupTableView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
    viewModel.days.bind(to: tableView) { viewModels, indexPath, tableView in
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)

      // Productionization: handle index not found better, at least report an error
      guard let viewModel = viewModels[safe: indexPath.row]
        else { return cell }
      cell.textLabel?.text = viewModel.date + " | " + viewModel.temperature
      return cell
    }
  }

  @objc func requestLocation() {
    viewModel.requestLocationPermission()
  }
}


