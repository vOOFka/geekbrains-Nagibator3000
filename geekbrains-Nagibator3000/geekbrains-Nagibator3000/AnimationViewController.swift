import UIKit

class AnimationViewController: UIViewController {
    private var current: UIViewController
    
    init() {
        self.current = MainTabBarViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        makeServiceCall()
    }

    private func makeServiceCall() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
            self.transitionToMain()
        }
    }
  
   private func transitionToMain() {
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
}

