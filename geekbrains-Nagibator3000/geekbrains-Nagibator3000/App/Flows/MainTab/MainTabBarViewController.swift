import UIKit

final class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfig()
    }
    
    //MARK: - Config
    
    private func initialConfig() {
        tabBar.backgroundColor = ColorScheme.greenPantone.color
        tabBar.tintColor = ColorScheme.white.color
        
        let translateViewController = UINavigationController(rootViewController: TranslateViewController())
        let dictionaryViewController = UINavigationController(rootViewController: DictionaryViewController())
        let trainingViewController = UINavigationController(rootViewController: TrainingViewController())
        
        translateViewController.title = String(localized: "Translate")
        dictionaryViewController.title = String(localized: "Dictionary")
        trainingViewController.title = String(localized: "Training")
        
        setViewControllers([translateViewController, dictionaryViewController, trainingViewController], animated: false)
        
        guard let items = tabBar.items else {
            return
        }
        
        let icons = ["doc.text.magnifyingglass","book.closed","rectangle.3.group.fill"]
        
        items.enumerated().forEach { index, item in
            item.image = UIImage(systemName: icons[index])
        }
    }
}
