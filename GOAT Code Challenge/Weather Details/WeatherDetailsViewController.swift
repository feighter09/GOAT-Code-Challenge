//
//  WeatherDetailsViewController.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/10/21.
//

import UIKit

class WeatherDetailsViewController: UIViewController {
  @IBOutlet private(set) weak var descriptionLabel: UILabel!

  private let viewModel: WeatherDetailsViewModel
  init(viewModel: WeatherDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented, use `init(viewModel:) instead") }
}

// MARK: - View Life Cycle
extension WeatherDetailsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    title = viewModel.title
    descriptionLabel.text = viewModel.description
  }
}
