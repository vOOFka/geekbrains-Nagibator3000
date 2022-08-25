//
//  TranslateViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 02.08.2022.
//

import Foundation
import RxCocoa
import RxSwift
import RxFlow
import RxRelay

final class TranslateViewModel: RxViewModelProtocol, Stepper {
  struct Input {
    let onTapFromLanguage: PublishRelay<Void>
    let onTapToLanguage: PublishRelay<Void>
    let onReverseLanguage: PublishRelay<Void>
    let onTranslate: PublishRelay<Void>
    let onSave: PublishRelay<Void>
    let onShare: PublishRelay<Void>
    let onCopy: PublishRelay<Void>
    let onText: AnyObserver<String>
    let onLanguageUpdated: PublishRelay<LanguageModel>
  }
  
  struct Output {
    let translateText: Driver<String>
    let sourceLanguage: Driver<LanguageModel>
    let destinationLanguage: Driver<LanguageModel>
    let reverseText: PublishRelay<Void>
    let showToast: PublishRelay<String>
  }
  
  private(set) var input: Input!
  private(set) var output: Output!
  private let disposeBag = DisposeBag()
  var steps = PublishRelay<Step>()
  
  private let translaterUseCase: TranslaterUseCase
  private let dictionaryUseCase: DictionaryUseCase
  
  // Input
  private let tapedFromLanguage = PublishRelay<Void>()
  private let tapedToLanguage = PublishRelay<Void>()
  private let tappedReverseLanguage = PublishRelay<Void>()
  private let translated = PublishRelay<Void>()
  private let saved = PublishRelay<Void>()
  private let shared = PublishRelay<Void>()
  private let copied = PublishRelay<Void>()
  private let languageUpdated = PublishRelay<LanguageModel>()
  private let languageSelectedIndex = BehaviorSubject<Int>(value: 0)
  private let texted = BehaviorSubject<String>(value: "")
  
  // Outut
  let reverseText = PublishRelay<Void>()
  let showToast = PublishRelay<String>()
  private let translatedText = BehaviorSubject<String>(value: "")
  private let sourceLanguage = BehaviorSubject<LanguageModel>(
    value: LanguageModel(code: "ru", name: "русский")
  )
  private let destinationLanguage = BehaviorSubject<LanguageModel>(
    value: LanguageModel(code: "en", name: "english")
  )
  
  init(
    translaterUseCase: TranslaterUseCase,
    dictionaryUseCase: DictionaryUseCase
  ) {
    self.translaterUseCase = translaterUseCase
    self.dictionaryUseCase = dictionaryUseCase
    
    input = Input(
      onTapFromLanguage: tapedFromLanguage,
      onTapToLanguage: tapedToLanguage,
      onReverseLanguage: tappedReverseLanguage,
      onTranslate: translated,
      onSave: saved,
      onShare: shared,
      onCopy: copied,
      onText: texted.asObserver(),
      onLanguageUpdated: languageUpdated
    )
    
    output = Output(
      translateText: translatedText.asDriver(onErrorJustReturn: ""),
      sourceLanguage: sourceLanguage
        .asDriver(onErrorJustReturn: LanguageModel(code: "none", name: "select")),
      destinationLanguage: destinationLanguage
        .asDriver(onErrorJustReturn: LanguageModel(code: "none", name: "select")),
      reverseText: reverseText,
      showToast: showToast
    )
    
    setupBind()
  }
  
  private func setupBind() {
    bindSwapLanguages()
    bindTapLanguages()
    bindTranslate()
    bindSave()
    bindCopy()
    bindShare()
  }
  
  private func bindSwapLanguages() {
    tappedReverseLanguage
      .withLatestFrom(
        Observable.combineLatest(
          sourceLanguage,
          destinationLanguage
        )
      )
      .bind { [weak self] from, to in
        self?.sourceLanguage.onNext(to)
        self?.destinationLanguage.onNext(from)
        self?.reverseText.accept(Void())
      }
      .disposed(by: disposeBag)
  }
  
  private func bindTapLanguages() {
    tapedFromLanguage
      .withLatestFrom(sourceLanguage)
      .map { [weak self] language in
        self?.languageSelectedIndex.onNext(0)
        
        return TranslateStep.openLanguagesRequiredScreen(language: language)
      }
      .bind(to: steps)
      .disposed(by: disposeBag)
    
    tapedToLanguage
      .withLatestFrom(destinationLanguage)
      .map { [weak self] language in
        self?.languageSelectedIndex.onNext(1)
        
        return TranslateStep.openLanguagesRequiredScreen(language: language)
      }
      .bind(to: steps)
      .disposed(by: disposeBag)
    
    languageUpdated
      .withLatestFrom(Observable.combineLatest(languageUpdated, languageSelectedIndex))
      .bind { [weak self] language, index in
        switch index {
        case 0:
          self?.sourceLanguage.onNext(language)
          
        case 1:
          self?.destinationLanguage.onNext(language)
          
        default:
          break;
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func bindTranslate() {
    translated
      .withLatestFrom(
        Observable.combineLatest(
          texted,
          sourceLanguage,
          destinationLanguage
        )
      )
      .filter { text, from, to in
        !text.isEmpty && from.code != "none" && to.code != "none"
      }
      .bind { [weak self] text, from, to in
        self?.translate(text: text, fromCode: from.code, toCode: to.code)
      }
      .disposed(by: disposeBag)
  }
  
  private func bindSave() {
    saved
      .withLatestFrom(Observable.combineLatest(texted, translatedText))
      .map { fromText, toText in TranslationModel(fromText: fromText, toText: toText) }
      .bind { [weak self] model in
        self?.saveToDictionary(model: model)
      }
      .disposed(by: disposeBag)
  }

  private func bindCopy() {
    copied
      .map { _ in Constants.copyText }
      .bind(to: showToast)
      .disposed(by: disposeBag)
  }
  
  private func bindShare() {
    shared
      .withLatestFrom(translatedText)
      .map { text in TranslateStep.openShareRequiredScreen(text: text)}
      .bind(to: steps)
      .disposed(by: disposeBag)
  }
  
  public func translate(text: String, fromCode: String, toCode: String) {
    let tanslateParams = TranslateParams(
      texts: text,
      sourceLanguageCode: fromCode,
      targetLanguageCode: toCode
    )
    
    translaterUseCase.traslate(fromText: text, params: tanslateParams)
      .subscribe { [weak self] event in
        guard let self = self else { return }
        switch event {
        case .next(let translate):
          self.translatedText.onNext(translate.toText)
          break
          
        case .error(let error):
          self.steps.accept(TranslateStep.error(self.map(error: error)))
          break
          
        default:
          break
        }
      }
      .disposed(by: disposeBag)
  }
  
  public func saveToDictionary(model: TranslationModel) {
    let fromText = model.fromText.trimmingCharacters(in: .whitespaces)
    let toText = model.toText.trimmingCharacters(in: .whitespaces)

    guard !fromText.isEmpty ,
          !toText.isEmpty else {
      
      self.showToast.accept(Constants.saveEmtyFailText)
      return
    }
    
    textIsExisted(model: TranslationModel(fromText: fromText, toText: toText))
      .subscribe(onNext: { [weak self] isExisted in
        if isExisted {
          self?.showToast.accept(Constants.saveExistsFailText)
        } else {
          self?.save(model: model)
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func save(model: TranslationModel) {
    dictionaryUseCase.add(model: model)
      .subscribe { [weak self] event in
        guard let self = self else { return }
        
        switch event {
        case.next(let completed):
          if completed {
            self.showToast.accept(Constants.saveText)
            break
          }
          
          self.showToast.accept(Constants.saveFailText)
          break
          
        case .error(let error):
          self.steps.accept(TranslateStep.error(self.map(error: error)))
          break
          
        default:
          break
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func textIsExisted(model: TranslationModel) ->  Observable<Bool> {
    dictionaryUseCase.get()
      .map { array in
        let index = array
          .firstIndex { value in value.fromText == model.fromText && value.toText == model.toText }
        
        return index != nil
    }
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

private enum Constants {
  static let copyText = "Copy".localized
  static let saveText = "Save".localized
  static let saveEmtyFailText = "Save.Error.Empty".localized
  static let saveExistsFailText = "Save.Error.Existed".localized
  static let saveFailText = "Save_Failed".localized
}
