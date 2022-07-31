import UIKit

final class TranslateViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorScheme.fuchsiaBlue.color
        title = String(localized: "Translate")
    }
}
