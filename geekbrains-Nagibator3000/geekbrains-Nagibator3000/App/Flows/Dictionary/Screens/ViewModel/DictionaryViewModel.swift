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

class DictionaryViewModel: RxViewModelProtocol, Stepper {
    struct Input {
        let enterScreen: PublishSubject<Void>
    }

    struct Output {
        let translations: Driver<[TranslationModel]>
    }

    private(set) var input: Input!
    private(set) var output: Output!
    
    private let disposeBag = DisposeBag()
    
    // Input
    private let enterScreen = PublishSubject<Void>()
    
    // Output
    let translations = BehaviorRelay<[TranslationModel]>(value: [])
    
    var steps = PublishRelay<Step>()
    
    private let dictionaryUseCase: DictionaryUseCase?
    
    init(dictionaryUseCase: DictionaryUseCase) {
        self.dictionaryUseCase = dictionaryUseCase
        
        input = Input(
            enterScreen: enterScreen
        )
        output = Output(
            translations: translations.asDriver(onErrorJustReturn: [])
        )
        
        setupBindings()
    }
    
    private func setupBindings() {
        bindEnterScreen()
    }
    
    private func bindEnterScreen() {
        enterScreen
            .flatMap { [weak self] in
                (self?.dictionaryUseCase?.get().asDriver(onErrorJustReturn: []))!
            }
            .bind(to: translations)
            .disposed(by: disposeBag)
    }
}
