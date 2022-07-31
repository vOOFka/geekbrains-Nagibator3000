import UIKit

final class TrainingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorScheme.white.color
        title = String(localized: "Training")
    }
}
