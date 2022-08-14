//
//  DictionaryViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 12.08.2022.
//

import Foundation
import RxCocoa
import RxSwift
import RxFlow
import RxRelay

class DictionaryViewModel: Stepper {
    private let disposeBag = DisposeBag()
    var steps = PublishRelay<Step>()
    
    private let dictionaryUseCase: DictionaryUseCase?
    
    init(dictionaryUseCase: DictionaryUseCase) {
        self.dictionaryUseCase = dictionaryUseCase
    }
}
