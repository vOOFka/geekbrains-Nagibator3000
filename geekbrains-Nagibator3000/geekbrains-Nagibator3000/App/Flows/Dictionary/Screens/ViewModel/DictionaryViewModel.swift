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
        let onDeleteItem: PublishRelay<TranslationModel>
    }
    
    struct Output {
        let translationsSections: Driver<[DictionarySectionModel]>
    }
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private let disposeBag = DisposeBag()
    
    // Input
    private let enterScreen = PublishSubject<Void>()
    private let deleteItem = PublishRelay<TranslationModel>()
    
    // Output
    let translationsSections = BehaviorRelay<[DictionarySectionModel]>(value: [])
    
    var steps = PublishRelay<Step>()
    
    let dictionaryUseCase: DictionaryUseCase
    
    init(dictionaryUseCase: DictionaryUseCase) {
        self.dictionaryUseCase = dictionaryUseCase
        
        input = Input(
            enterScreen: enterScreen,
            onDeleteItem: deleteItem
        )
        output = Output(
            translationsSections: translationsSections.asDriver(onErrorJustReturn: [])
        )
        
        setupBindings()
    }
    
    private func setupBindings() {
        bindEnterScreen()
        bindDeleteItem()
    }
    
    private func configSections() -> Observable<[DictionarySectionModel]> {
        dictionaryUseCase.get().compactMap { [DictionarySectionModel(header: "", items: $0)] }
    }
    
    private func bindEnterScreen() {
        enterScreen
            .flatMap { self.configSections() }
            .bind(to: translationsSections)
            .disposed(by: disposeBag)
    }
    
    private func deleteFromRepositiry(model: TranslationModel) {
        dictionaryUseCase.delete(model: model)
            .subscribe { [weak self] event in
                switch event {
                case.next(_):
                    guard let self = self else {
                        return
                    }
                    self.configSections()
                        .bind(to: self.translationsSections)
                        .disposed(by: self.disposeBag)
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
    
    private func bindDeleteItem() {
        deleteItem        
            .bind { [weak self] model in
                self?.deleteFromRepositiry(model: model)
            }
            .disposed(by: disposeBag)
    }
}
