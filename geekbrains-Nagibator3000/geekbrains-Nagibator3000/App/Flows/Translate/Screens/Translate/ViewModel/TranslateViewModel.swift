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
    let onTranslate: PublishRelay<String>
    let onSave: PublishRelay<Void>
    let onShare: PublishRelay<Void>
    let onCopy: PublishRelay<Void>
    let onLanguageUpdated: PublishRelay<LanguageModel>
  }
  
  struct Output {
    let translateText: Driver<TranslationModel>
    let sourceLanguage: Driver<LanguageModel>
    let destinationLanguage: Driver<LanguageModel>
    let reverseText: PublishRelay<Void>
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
  private let translated = PublishRelay<String>()
  private let saved = PublishRelay<Void>()
  private let shared = PublishRelay<Void>()
  private let copied = PublishRelay<Void>()
  private let languageUpdated = PublishRelay<LanguageModel>()
  private let languageSelectedIndex = BehaviorSubject<Int>(value: 0)
  
  // Outut
  let reverseText = PublishRelay<Void>()
  private let translatedText = BehaviorSubject<TranslationModel>(
    value: TranslationModel(fromText: "", toText: "")
  )
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
      onLanguageUpdated: languageUpdated
    )
    
    output = Output(
      translateText: translatedText
        .asDriver(onErrorJustReturn: TranslationModel(fromText: "", toText: "")),
      sourceLanguage: sourceLanguage
        .asDriver(onErrorJustReturn: LanguageModel(code: "none", name: "select")),
      destinationLanguage: destinationLanguage
        .asDriver(onErrorJustReturn: LanguageModel(code: "none", name: "select")),
      reverseText: reverseText
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
          translated,
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
      .withLatestFrom(translatedText)
      .bind { [weak self] text in
        self?.saveToDictionary(model: text)
      }
      .disposed(by: disposeBag)
  }

  private func bindCopy() {
    copied
      .bind { _ in
        // ToDo в будущем тут будет вызов тоста об успешном копирования текста
      }
      .disposed(by: disposeBag)
  }
  
  private func bindShare() {
    shared
      .withLatestFrom(translatedText)
      .map { model in TranslateStep.openShareRequiredScreen(text: model.toText)}
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
        switch event {
        case .next(let translate):
          self?.translatedText.onNext(translate)
          break
          
        case .error(let error):
          print(error)
          break
          
        default:
          break
        }
      }
      .disposed(by: disposeBag)
  }
  
  public func saveToDictionary(model: TranslationModel) {
    dictionaryUseCase.add(model: model)
      .subscribe { event in
        switch event {
        case.next(_):
          // ToDo  в будущем тут будет вызов тоста об успешном сохранении текста
          break
          
        case .error(let error):
          print(error)
          break
          
        default:
          break
        }
      }
      .disposed(by: disposeBag)
  }
}
