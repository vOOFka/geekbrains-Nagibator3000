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
      .subscribe(onCompleted: { [weak self] in
        self?.steps.accept(AnimationStep.goToApp)
      }, onError: { [weak self] error in
        guard let self = self else { return }
        
        self.stopAnimation.accept(Void())
        self.steps.accept(AnimationStep.error(self.map(error: error)))
      })
      .disposed(by: disposeBag)
  }
  
  private func map(error: Error) -> ErrorType {
   switch error {
   case _ as Unauthorized:
     return .unauthorized

   case _ as InternetConnectionLost:
     return .internetConnectionLost
     
   default:
     return .otherError
   }
 }
}
