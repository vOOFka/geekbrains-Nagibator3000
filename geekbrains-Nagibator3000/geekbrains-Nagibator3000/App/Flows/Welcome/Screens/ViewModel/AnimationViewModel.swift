//
//  AnimationViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Константин Каменчуков on 12.08.2022.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

class AnimationViewModel: RxViewModelProtocol, Stepper {
  struct Input {
    let enterScreen: PublishRelay<Void>
  }

  struct Output {
    let startAnimation: Driver<Void?>
    let stopAnimation: Driver<Void?>
  }

  private(set) var input: Input!
  private(set) var output: Output!
  private var loadUseCase: LanguageUseCase

  private let disposeBag = DisposeBag()
  
  // Input
  private let enterScreen = PublishRelay<Void>()

  // Output
  private let startAnimation = BehaviorRelay<Void?>(value: nil)
  private let stopAnimation = BehaviorRelay<Void?>(value: nil)
  
  var steps = PublishRelay<Step>()
  
  public init(loadUseCase: LanguageUseCase) {
    input = Input(
      enterScreen: enterScreen
    )
    output = Output(
      startAnimation: startAnimation.asDriver(onErrorJustReturn: nil),
      stopAnimation: stopAnimation.asDriver(onErrorJustReturn: nil)
    )

    self.loadUseCase = loadUseCase
    setupBindings()
  }

  private func setupBindings() {
    bindEnterScreen()
  }

  private func bindEnterScreen() {
    enterScreen
      .bind { action in
        self.startAnimation.accept(action)
        self.loadLanguages()
      }
      .disposed(by: disposeBag)
  }
  
  private func loadLanguages() {
    loadUseCase.load()
      .delay(.seconds(2), scheduler: MainScheduler.instance)
      .map { [weak self] completed in
        self?.stopAnimation.accept(Void())
        
        guard completed else {
          return AnimationStep.error
        }
        
        return AnimationStep.goToApp
      }
      .bind(to: self.steps)
      .disposed(by: disposeBag)
  }
}
