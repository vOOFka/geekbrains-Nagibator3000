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
        configTabBarAppearance()
        configNavBarAppearance()
    }
    
    private func configTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Constants.greenColor
        appearance.selectionIndicatorTintColor = Constants.whiteColor
        appearance.shadowColor = Constants.greenColor
        
        updateTabBarItemAppearance(appearance: appearance.compactInlineLayoutAppearance)
        updateTabBarItemAppearance(appearance: appearance.inlineLayoutAppearance)
        updateTabBarItemAppearance(appearance: appearance.stackedLayoutAppearance)
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
    }
    
    private func updateTabBarItemAppearance(appearance: UITabBarItemAppearance) {
        let tintColor: UIColor = Constants.whiteColor
        let unselectedItemTintColor: UIColor = Constants.blackColor
        
        appearance.selected.iconColor = tintColor
        appearance.selected.titleTextAttributes = [.foregroundColor : tintColor]
        appearance.normal.iconColor = unselectedItemTintColor
        appearance.normal.titleTextAttributes = [.foregroundColor : unselectedItemTintColor]
    }
}

private enum Constants {
    // Color
    static let greenColor = ColorScheme.greenPantone.color
    static let whiteColor = ColorScheme.white.color
    static let blackColor = ColorScheme.black.color
}
