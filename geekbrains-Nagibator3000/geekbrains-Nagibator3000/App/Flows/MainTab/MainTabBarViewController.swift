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
    
    //MARK: - Config
    
    private func initialConfig() {
        tabBar.backgroundColor = Constants.greenColor
        tabBar.tintColor = Constants.whiteColor
        
        let translateViewModel = TranslateViewModel()
        
        let translateViewController = UINavigationController(rootViewController: TranslateViewController(viewModel: translateViewModel))
        let dictionaryViewController = UINavigationController(rootViewController: DictionaryViewController())
        let trainingViewController = UINavigationController(rootViewController: TrainingViewController())
        
        translateViewController.title = Constants.titleTranslateViewController
        dictionaryViewController.title = Constants.titleDictionaryViewController
        trainingViewController.title = Constants.titleTranslateViewController
        
        setViewControllers([translateViewController, dictionaryViewController, trainingViewController], animated: false)
        
        guard let items = tabBar.items else {
            return
        }
        
        let icons = [Constants.iconTranslateViewController,
                     Constants.iconDictionaryViewController,
                     Constants.iconTrainingViewController]
        
        items.enumerated().forEach { index, item in
            item.image = UIImage(systemName: icons[index])
        }
    }
}

//MARK: - Constants

private enum Constants {
    static let titleTranslateViewController = "Translate".localized
    static let titleDictionaryViewController = "Dictionary".localized
    static let titleTrainingViewController = "Training".localized
    
    static let greenColor = ColorScheme.greenPantone.color
    static let whiteColor = ColorScheme.white.color
    
    static let iconTranslateViewController = "doc.text.magnifyingglass"
    static let iconDictionaryViewController = "book.closed"
    static let iconTrainingViewController = "rectangle.3.group.fill"
}
