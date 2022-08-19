//
//  DictionaryTableCellViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 19.08.2022.
//

import Foundation
import RxCocoa
import RxSwift

class DictionaryTableCellViewModel {
    var text: Driver<String>
    var translation: Driver<String>
    
    init(with translation: TranslationModel) {
        self.text = .just(translation.fromText)
        self.translation = .just(translation.toText)
    }
}
