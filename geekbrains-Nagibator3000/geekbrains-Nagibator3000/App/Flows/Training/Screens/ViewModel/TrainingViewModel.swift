//
//  TrainingViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 12.08.2022.
//

import Foundation
import RxFlow
import RxRelay
import RxSwift
import RxCocoa

class TrainingViewModel: RxViewModelProtocol, Stepper {
  var steps = PublishRelay<Step>()
  
  struct Input {
    let enterScreen: PublishSubject<Void>
  }
  
  struct Output {
    let source: Driver<[TranslationModel]>
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  
  private let disposeBag = DisposeBag()
  private let dictionaryUseCase: DictionaryUseCase
  
  // Input
  private let enterScreen = PublishSubject<Void>()
  
  // Output
  let source = BehaviorRelay<[TranslationModel]>(value: [])
  
  init(dictionaryUseCase: DictionaryUseCase) {
    self.dictionaryUseCase = dictionaryUseCase
    
    input = Input(
      enterScreen: enterScreen
    )
    output = Output(
      source: source.asDriver(onErrorJustReturn: [])
    )
    
    setupBindings()
  }
  
  private func setupBindings() {
    bindEnterScreen()
  }
  
  private func bindEnterScreen() {
    enterScreen
      .flatMap { self.dictionaryUseCase.get() }
      .bind(to: source)
      .disposed(by: disposeBag)
  }
}

