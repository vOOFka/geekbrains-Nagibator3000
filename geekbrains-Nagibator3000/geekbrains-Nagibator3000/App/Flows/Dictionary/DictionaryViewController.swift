import UIKit

final class DictionaryViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorScheme.raspberryRose.color
        title = String(localized: "Dictionary")
    }
}
