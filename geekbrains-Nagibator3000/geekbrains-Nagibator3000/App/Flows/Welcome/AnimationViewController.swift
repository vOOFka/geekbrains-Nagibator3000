//
//  AnimationViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Constantin on 29.07.2022.
//

import UIKit
import Lottie
import RxFlow

class AnimationViewController: UIViewController {
    private var animationView: AnimationView?
    
    init() {
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
        animationView.play { [weak self] _ in
            self?.completionAnimation()
            }
    }
    
    private func completionAnimation() {
      let coordinator = FlowCoordinator()
      let flow = MainFlow(window: self.view.window!) // это временная строка запуск флоу будет происходить из главного флоу после анимации
      
      coordinator.coordinate(
        flow: flow,
        with: OneStepper(
          withSingleStep: MainStep.goToApp
        )
      )
    }
}
