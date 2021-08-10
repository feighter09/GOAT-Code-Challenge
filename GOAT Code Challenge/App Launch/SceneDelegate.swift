//
//  SceneDelegate.swift
//  GOAT Code Challenge
//
//  Created by Austin Feight on 8/9/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var coordinator: WeatherListCoordinatorType = WeatherListCoordinator()

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(frame: UIScreen.main.bounds)
    window.windowScene = scene
    window.makeKeyAndVisible()
    self.window = window

    window.rootViewController = coordinator.start()
  }
}
