//
//  DictionaryViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 12.08.2022.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

final class DictionaryViewModel: RxViewModelProtocol, Stepper {
    struct Input {
        let enterScreen: PublishSubject<Void>
    }

    struct Output {
        let translationsSections: Driver<[TranslationSectionModel]>
    }

    private(set) var input: Input!
    private(set) var output: Output!
    
    private let disposeBag = DisposeBag()
    
    // Input
    private let enterScreen = PublishSubject<Void>()
    
    // Output
    let translationsSections = BehaviorRelay<[TranslationSectionModel]>(value: [])
    
    var steps = PublishRelay<Step>()
    
    private let dictionaryUseCase: DictionaryUseCase?
    
    init(dictionaryUseCase: DictionaryUseCase) {
        self.dictionaryUseCase = dictionaryUseCase
        
        input = Input(
            enterScreen: enterScreen
        )
        output = Output(
            translationsSections: translationsSections.asDriver(onErrorJustReturn: [])
        )
        
        setupBindings()
    }
    
    private func setupBindings() {
        bindEnterScreen()
    }
    
    private func configSections() -> Observable<[TranslationSectionModel]>? {
        dictionaryUseCase?.get().compactMap { [TranslationSectionModel(header: "", items: $0)] }
    }
    
    private func bindEnterScreen() {
        enterScreen
            .withLatestFrom(configSections()!)
            .bind(to: translationsSections)
            .disposed(by: disposeBag)
    }
}
