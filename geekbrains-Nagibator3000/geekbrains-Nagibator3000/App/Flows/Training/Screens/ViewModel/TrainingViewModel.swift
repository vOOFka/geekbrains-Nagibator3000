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
    let onAdd: PublishRelay<Void>
    let delete: PublishRelay<Int>
  }
  
  struct Output {
    let source: Driver<[TranslationModel]>
    let state: Driver<States>
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  
  private let disposeBag = DisposeBag()
  private let dictionaryUseCase: DictionaryUseCase
  
  // Input
  private let enterScreen = PublishSubject<Void>()
  private let tapAdd = PublishRelay<Void>()
  private let delete = PublishRelay<Int>()
  
  // Output
  let source = BehaviorRelay<[TranslationModel]>(value: [])
  let state = BehaviorRelay<States>(value: .load)
  
  init(dictionaryUseCase: DictionaryUseCase) {
    self.dictionaryUseCase = dictionaryUseCase
    
    input = Input(
      enterScreen: enterScreen,
      onAdd: tapAdd,
      delete: delete
    )
    output = Output(
      source: source.asDriver(onErrorJustReturn: []),
      state: state.asDriver(onErrorJustReturn: .empty)
    )
    
    setupBindings()
  }
  
  private func setupBindings() {
    bindEnterScreen()
    bindAdd()
    bindDelete()
  }
  
  private func bindEnterScreen() {
    enterScreen
      .bind { action in
        self.state.accept(.load)
        self.loadDict()
          .bind(to: self.source)
          .disposed(by: self.disposeBag)
      }
      .disposed(by: disposeBag)
  }
  
  private func bindDelete() {
    delete
      .withLatestFrom(Observable.combineLatest(delete, source))
      .bind { [weak self] index, source in
        let model = source[index]
        self?.deleteFromRepositiry(model: model)
      }
      .disposed(by: disposeBag)
  }
  
  private func deleteFromRepositiry(model: TranslationModel) {
    dictionaryUseCase.delete(model: model)
      .subscribe(onNext: { _ in })
      .disposed(by: disposeBag)
  }
  
  private func loadDict() -> Observable<[TranslationModel]> {
    Observable<[TranslationModel]>.create { [weak self] observable in
      guard let self = self else { return Disposables.create() }
      self.dictionaryUseCase.get()
        .subscribe { event in
          switch event {
          case .next(let values):
            if values.isEmpty {
              self.state.accept(.empty)
            } else {
              observable.onNext(values)
              observable.onCompleted()
              self.state.accept(.completed)
            }
            
          case .error(let error):
            observable.onError(error)
          default:
            break
          }
        }.disposed(by: self.disposeBag)
      return Disposables.create()
    }
  }
  
  private func bindAdd() {
    tapAdd
      .map { _ in TrainingStep.translate }
      .bind(to: steps)
      .disposed(by: disposeBag)
  }
}

enum States {
  case load, empty, completed
}
