//
//  WeatherListCoordinatorSpec.swift
//  GOAT Code ChallengeTests
//
//  Created by Austin Feight on 8/9/21.
//

@testable import GOAT_Code_Challenge

import Nimble
import Quick

class WeatherListCoordinatorSpec: QuickSpec {}

// MARK: - Tests
extension WeatherListCoordinatorSpec {
  override func spec() {
    var subject: WeatherListCoordinator!

    beforeEach {
      subject = WeatherListCoordinator()
    }

    describe("start()") {
      it("returns a WeatherListViewController embedded in a navigation controller") {
        let result = subject.start()

        expect(result).to(beAnInstanceOf(UINavigationController.self))

        let vc = (result as? UINavigationController)?.viewControllers.first
        expect(vc).to(beAnInstanceOf(WeatherListViewController.self))
      }
    }
  }
}
