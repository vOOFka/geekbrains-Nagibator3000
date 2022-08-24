//
//  MainFlow.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Swinject
import RxFlow
import UIKit

final class MainFlow: Flow {
    private(set) var window: UIWindow
    let container: Container!
    
    var root: Presentable {
        self.window
    }
    
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
        
        setUpDiContainer()
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MainStep else { return .none }
        
        switch step {
        case .goToApp:
            return goTotheApp()
        }
    }
    
    private func goTotheApp() -> FlowContributors {
        // create view models
        let translateViewModel = TranslateViewModel(
            translaterUseCase: container.resolve(TranslaterUseCase.self)!,
            dictionaryUseCase: container.resolve(DictionaryUseCase.self)!
        )
        
        let dictionaryViewModel = DictionaryViewModel(
            dictionaryUseCase: container.resolve(DictionaryUseCase.self)!
        )
        
        let trainingViewModel = TrainingViewModel()
        
        // create viewControllers
        let translateViewController = TranslateViewController()
        let dictionaryViewController = DictionaryViewController()
        let trainingViewController = TrainingViewController()
        
        let translateItem = UITabBarItem(
            title: Constants.titleTranslateViewController,
            image: UIImage(systemName: Constants.iconTranslateViewController),
            selectedImage: nil
        )
        
        let dictionaryItem = UITabBarItem(
            title: Constants.titleDictionaryViewController,
            image: UIImage(systemName: Constants.iconDictionaryViewController),
            selectedImage: nil
        )
        
        let trainingItem = UITabBarItem(
            title: Constants.titleTrainingViewController,
            image: UIImage(systemName: Constants.iconTrainingViewController),
            selectedImage: nil
        )
        
        translateViewController.viewModel = translateViewModel
        translateViewController.tabBarItem = translateItem
        
        dictionaryViewController.viewModel = dictionaryViewModel
        dictionaryViewController.tabBarItem = dictionaryItem
        
        trainingViewController.viewModel = trainingViewModel
        trainingViewController.tabBarItem = trainingItem
        
        
        // create flows
        let translateFlow = TranslateFlow(viewController: translateViewController, container: container)
        let dictionaryFlow = DictionaryFlow(viewController: dictionaryViewController)
        let trainingFlow = TrainingFlow(viewController: trainingViewController)
        
        let tabController = MainTabBarViewController()
        
        tabController.setViewControllers(
            [
                translateViewController,
                dictionaryViewController,
                trainingViewController
            ],
            animated: false
        )
        
        let navController = UINavigationController()
        navController.pushViewController(tabController, animated: true)
        window.rootViewController = navController
        
        return .multiple(flowContributors: [
            .contribute(
                withNextPresentable: translateFlow,
                withNextStepper: translateViewModel
            ),
            .contribute(
                withNextPresentable: dictionaryFlow,
                withNextStepper: dictionaryViewModel
            ),
            .contribute(
                withNextPresentable: trainingFlow,
                withNextStepper: trainingViewModel
            )
        ])
    }
}

private enum Constants {
    // Strings
    static let titleTranslateViewController = "Translate".localized
    static let titleDictionaryViewController = "Dictionary".localized
    static let titleTrainingViewController = "Training".localized
    
    // Images
    static let iconTranslateViewController = "doc.text.magnifyingglass"
    static let iconDictionaryViewController = "book.closed"
    static let iconTrainingViewController = "rectangle.3.group.fill"
}
