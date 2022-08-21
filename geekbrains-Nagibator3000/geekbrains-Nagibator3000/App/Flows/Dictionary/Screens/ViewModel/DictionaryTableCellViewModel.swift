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
    var text: String
    var translation: String
    var translationModel: TranslationModel
    
    init(with translation: TranslationModel) {
        self.text = translation.fromText
        self.translation = translation.toText
        self.translationModel = translation
    }
}
