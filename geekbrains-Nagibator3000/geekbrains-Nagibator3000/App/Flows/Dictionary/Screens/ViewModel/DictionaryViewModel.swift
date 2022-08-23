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
        let showToast: PublishRelay<String>
    }
    
    private(set) var input: Input!
    private(set) var output: Output!
    
    private let disposeBag = DisposeBag()
    
    // Input
    private let enterScreen = PublishSubject<Void>()
    private let deleteItem = PublishRelay<TranslationModel>()
    
    // Output
    let translationsSections = BehaviorRelay<[DictionarySectionModel]>(value: [])
    let showToast = PublishRelay<String>()
    
    var steps = PublishRelay<Step>()
    
    let dictionaryUseCase: DictionaryUseCase
    
    init(dictionaryUseCase: DictionaryUseCase) {
        self.dictionaryUseCase = dictionaryUseCase
        
        input = Input(
            enterScreen: enterScreen,
            onDeleteItem: deleteItem
        )
        output = Output(
            translationsSections: translationsSections.asDriver(onErrorJustReturn: []),
            showToast: showToast
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
        .map { _ in DictionaryStep.error(.otherError)}
        .bind(to: steps)
        .disposed(by: disposeBag)
    }
    
    private func reloadSections() {
        configSections()
            .bind(to: self.translationsSections)
            .disposed(by: self.disposeBag)
    }
    
    private func deleteFromRepositiry(model: TranslationModel) {
        dictionaryUseCase.delete(model: model)
            .subscribe { [weak self] event in
                switch event {
                case.next(let completed):
                    self?.reloadSections()                    
                    if !completed {
                        self?.showToast.accept(Constants.deleteFailText)
                    }
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

private enum Constants {
  static let deleteFailText = "Delete_Failed".localized
}
