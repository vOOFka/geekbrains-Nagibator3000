//
//  AnimationViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Константин Каменчуков on 12.08.2022.
//

import UIKit
import RxFlow
import RxCocoa
import RxSwift

class AnimationViewModel: RxViewModelProtocol, Stepper {
  struct Input {
    let enterScreen: PublishRelay<Void>
    let completionAnimation: PublishRelay<Void>
  }

  struct Output {
    let startAnimation: Driver<Void?>
  }

  private(set) var input: Input!
  private(set) var output: Output!

  private let disposeBag = DisposeBag()
  
  // Input
  private let enterScreen = PublishRelay<Void>()
  private let completionAnimation = PublishRelay<Void>()

  // Output
  private let startAnimation = BehaviorRelay<Void?>(value: nil)
  
  var steps = PublishRelay<Step>()
  
  public init() {
    input = Input(
      enterScreen: enterScreen,
      completionAnimation: completionAnimation
    )
    output = Output(
      startAnimation: startAnimation.asDriver(onErrorJustReturn: nil)
    )

    setupBindings()
  }

  private func setupBindings() {
    bindEnterScreen()
    bindCompletionAnimation()
  }

  private func bindEnterScreen() {
    enterScreen
      .bind(to: startAnimation)
      .disposed(by: disposeBag)
  }

  private func bindCompletionAnimation() {
    completionAnimation
      .map { _ in AnimationStep.goToApp }
      .bind(to: steps)
      .disposed(by: disposeBag)
  }
}
