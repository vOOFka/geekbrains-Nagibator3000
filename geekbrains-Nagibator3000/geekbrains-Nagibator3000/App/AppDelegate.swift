//
//  AppDelegate.swift
//  geekbrains-Nagibator3000
//
//  Created by Constantin on 29.07.2022.
//

import UIKit
import RxFlow
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let animationFlow = AnimationFlow(window: window!)
        coordinator.coordinate(flow: animationFlow,
                               with: OneStepper(withSingleStep: AnimationStep.animationScreen))
        return true
    }
}

