import UIKit

final class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = true
        tabBar.backgroundColor = ColorScheme.greenPantone.color
        tabBar.tintColor = ColorScheme.white.color
        
        let translateViewController = TranslateViewController()
        let dictionaryViewController = DictionaryViewController()
        let trainingViewController = TrainingViewController()
        
        translateViewController.title = String(localized: "Translate")
        dictionaryViewController.title = String(localized: "Dictionary")
        trainingViewController.title = String(localized: "Training")
        
        setViewControllers([translateViewController, dictionaryViewController, trainingViewController], animated: false)
    } 
}
