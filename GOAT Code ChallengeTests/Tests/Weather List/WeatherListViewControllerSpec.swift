//
//  WeatherListViewControllerSpec.swift
//  GOAT Code ChallengeTests
//
//  Created by Austin Feight on 8/9/21.
//

@testable import GOAT_Code_Challenge

import Nimble
import Quick

class WeatherListViewControllerSpec: QuickSpec {
  var viewModel: MockWeatherListViewModel!
}

// MARK: - Tests
extension WeatherListViewControllerSpec {
  override func spec() {
    var subject: WeatherListViewController!

    beforeEach {
      subject = self.newSubject
    }

    describe("the location permission button") {
      it("is added to the nav bar") {
        expect(subject.permissionButton?.title).to(equal("Allow Location"))
      }

      context("when tapped") {
        beforeEach {
          subject.permissionButton?.tap()
        }

        it("calls viewModel.requestLocationPermission") {
          expect(self.viewModel.requestLocationPermissionCalled).to(beTrue())
        }
      }
    }

    describe("the tableView") {
      it("fails") { XCTFail() }
    }
  }
}

// MARK: - Helpers
private extension WeatherListViewControllerSpec {
  var newSubject: WeatherListViewController {
    viewModel = MockWeatherListViewModel()

    let subject = WeatherListViewController(viewModel: viewModel)
    subject.loadViewIfNeeded()
    return subject
  }
}

private extension WeatherListViewController {
  var permissionButton: UIBarButtonItem? {
    navigationItem.rightBarButtonItem
  }
}

private extension UIBarButtonItem {
  func tap() {
    guard let target = target, let action = action
      else { return }

    _ = target.perform(action)
  }
}

// MARK: - Mocks
final class MockWeatherListViewModel: WeatherListViewModelType {
  var requestLocationPermissionCalled = false
  func requestLocationPermission() { requestLocationPermissionCalled = true }
}
