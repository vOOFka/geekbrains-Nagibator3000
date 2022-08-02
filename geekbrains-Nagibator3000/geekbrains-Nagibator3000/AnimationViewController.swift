import UIKit
import Lottie

class AnimationViewController: UIViewController {
    private var current: UIViewController
    private var animationView: AnimationView?
    
    init() {
        self.current = MainTabBarViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configAnimation()
    }

    private func configAnimation() {
        animationView = .init(name: "Book")
        guard let animationView = animationView else { return }
        animationView.frame = view.bounds
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.1
        view.addSubview(animationView)
        animationView.play(completion: { [self] _ in
                animationView.stop()
                addChild(self.current)
                current.view.frame = view.bounds
                view.addSubview(current.view)
                current.didMove(toParent: self)
            })
    }
}

