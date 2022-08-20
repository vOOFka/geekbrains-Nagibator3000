//
//  SelectLanguageViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 05.08.2022.
//

import RxSwift
import RxCocoa
import RxFlow

final class SelectLanguageViewModel: RxViewModelProtocol, Stepper {
  struct Input {
    let enterScreen: PublishRelay<Void>
    let selectedCell: AnyObserver<Int>
  }

  struct Output {
    let source: Driver<[LanguagesListModel]>
  }

  private(set) var input: Input!
  private(set) var output: Output!
  
  private let disposeBag = DisposeBag()
  var steps = PublishRelay<Step>()
  
  private let carrentLanguages: LanguageModel
  private let languagesUseVase: LanguageUseCase
  
  // Input
  private let enterScreen = PublishRelay<Void>()
  private let selectedCell = BehaviorSubject<Int>(value: 0)
  
  // Output
  private let source = BehaviorSubject<[LanguagesListModel]>(value: [])

  init(carrentLanguages: LanguageModel, languagesUseCase: LanguageUseCase) {
    self.carrentLanguages = carrentLanguages
    self.languagesUseVase = languagesUseCase
    
    input = Input(enterScreen: enterScreen, selectedCell: selectedCell.asObserver())
    output = Output(source:  source.asDriver(onErrorJustReturn: []))
    
    setupBindings()
  }
  
  private func setupBindings() {
    bindLifeCycle()
    bindSelectCell()
  }
  
  private func bindLifeCycle() {
    enterScreen
      .bind { [weak self] _ in
        guard let self = self else { return }
        
        self.languagesUseVase.get()
          .subscribe(onNext: { [weak self] models in
            guard let self = self else { return }
            
            self.source.onNext(
              [LanguagesListModel(items: self.getCellModel(languages: models))]
            )
          })
          .disposed(by: self.disposeBag)
      }
      .disposed(by: disposeBag)
  }
  
  private func bindSelectCell() {
    selectedCell
      .withLatestFrom(Observable.combineLatest(selectedCell, source))
      .filter { _, source in !source.isEmpty }
      .map { index, source in
        let model = source[0].items[index]
        
        return TranslateStep.selectedLanguage(language: model.language)
      }
      .bind(to: steps)
      .disposed(by: disposeBag)
  }
  
  private func getCellModel(languages: [LanguageModel]) -> [SelectLanguageCellModel] {
    languages.map { language in
      SelectLanguageCellModel(language: language, selected: carrentLanguages.code == language.code)
    }
  }
}
