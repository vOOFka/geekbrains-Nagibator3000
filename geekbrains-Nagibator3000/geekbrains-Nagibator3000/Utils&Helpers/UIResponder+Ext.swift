//
//  UIResponder+Ext.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 02.08.2022.
//

import UIKit

extension UIResponder {
    func customNavBarAppearance() -> UINavigationBarAppearance {
        let customNavBarAppearance = UINavigationBarAppearance()
        
        customNavBarAppearance.configureWithOpaqueBackground()
        customNavBarAppearance.backgroundColor = Constants.greenColor
        
        customNavBarAppearance.titleTextAttributes = [.foregroundColor: Constants.whiteColor]
        customNavBarAppearance.largeTitleTextAttributes = [.foregroundColor: Constants.whiteColor]

        let barButtonItemAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonItemAppearance.normal.titleTextAttributes = [.foregroundColor: Constants.whiteColor]
        barButtonItemAppearance.disabled.titleTextAttributes = [.foregroundColor: Constants.whiteColor]
        barButtonItemAppearance.highlighted.titleTextAttributes = [.foregroundColor: Constants.whiteColor]
        barButtonItemAppearance.focused.titleTextAttributes = [.foregroundColor: Constants.whiteColor]
        customNavBarAppearance.buttonAppearance = barButtonItemAppearance
        customNavBarAppearance.backButtonAppearance = barButtonItemAppearance
        customNavBarAppearance.doneButtonAppearance = barButtonItemAppearance
        
        return customNavBarAppearance
    }
}

//MARK: - Constants

private enum Constants {
    static let whiteColor = ColorScheme.white.color
    static let greenColor = ColorScheme.greenPantone.color
}
