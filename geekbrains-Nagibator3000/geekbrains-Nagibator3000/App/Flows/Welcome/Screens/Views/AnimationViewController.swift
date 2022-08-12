//
//  AnimationViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Constantin on 29.07.2022.
//

import UIKit
import Lottie

class AnimationViewController: UIViewController {
    private var animationView: AnimationView?
    public var viewModel: AnimationViewModel!
    
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
        let mainTabBarViewController = MainTabBarViewController()
        addChild(mainTabBarViewController)
        mainTabBarViewController.view.frame = view.bounds
        view.addSubview(mainTabBarViewController.view)
        mainTabBarViewController.didMove(toParent: self)
    }
}
