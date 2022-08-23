//
//  DictionaryTableCellViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 19.08.2022.
//

import Foundation
import RxCocoa
import RxSwift

final public class DictionaryTableCellViewModel {
    private(set) var text: String
    private(set) var translation: String
    private(set) var translationModel: TranslationModel
    private(set) var isPrepareForDelete = false
    
    init(with translation: TranslationModel) {
        self.text = translation.fromText
        self.translation = translation.toText
        self.translationModel = translation
    }
    
    public func state() {
        isPrepareForDelete.toggle()
    }
}
