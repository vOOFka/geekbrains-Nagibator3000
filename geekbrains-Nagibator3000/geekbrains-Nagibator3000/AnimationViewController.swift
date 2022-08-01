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
        makeServiceCall()
    }

    private func makeServiceCall() {
        animationSet()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
            self.animationView?.stop()
            self.transitionToMain()
        }
    }
    
    private func animationSet() {
        animationView = .init(name: "Book")
        animationView?.frame = view.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .playOnce
        animationView?.animationSpeed = 1.1
        view.addSubview(animationView!)
        animationView?.play()
    }
  
   private func transitionToMain() {
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
}

