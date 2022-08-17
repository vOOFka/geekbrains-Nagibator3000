//
//  AnimationViewController.swift
//  geekbrains-Nagibator3000
//
//  Created by Constantin on 29.07.2022.
//

import UIKit
import Lottie
import RxSwift

class AnimationViewController: UIViewController {
  public var viewModel: AnimationViewModel!
  private var animationView: AnimationView!
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupAnimation()
    setupBindings()
  }
  
  private func setupAnimation() {
    animationView = AnimationView(name: "Book")
    animationView.frame = view.bounds
    animationView.backgroundColor = .white
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .autoReverse
    animationView.animationSpeed = 1.1
    view.addSubview(animationView)
  }
  
  private func setupBindings() {
    bindLifeCycle()
    bindStartAnimation()
    bindStopAnimation()
  }
  
  private func bindLifeCycle() {
    rx.viewWillAppear
      .bind(to: viewModel.input.enterScreen)
      .disposed(by: disposeBag)
  }

  private func bindStartAnimation() {
    viewModel.output.startAnimation
      .filter { $0 != nil }
      .drive { [weak self] _ in
        self?.animationView.play()
      }
      .disposed(by: disposeBag)
  }

  private func bindStopAnimation() {
    viewModel.output.stopAnimation
      .filter { $0 != nil }
      .drive { [weak self] _ in
        self?.animationView.stop()
      }
      .disposed(by: disposeBag)
  }
}
