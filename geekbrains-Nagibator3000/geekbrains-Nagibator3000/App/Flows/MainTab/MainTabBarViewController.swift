//
//  MainTabBarViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Constantin on 29.07.2022.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
  override func viewDidLoad() {
     super.viewDidLoad()
     initialConfig()
   }

   private func initialConfig() {
     tabBar.backgroundColor = Constants.greenColor
     tabBar.tintColor = Constants.whiteColor

     configNavBarAppearance()
   }
}

private enum Constants {
  // Color
  static let greenColor = ColorScheme.greenPantone.color
  static let whiteColor = ColorScheme.white.color
}
