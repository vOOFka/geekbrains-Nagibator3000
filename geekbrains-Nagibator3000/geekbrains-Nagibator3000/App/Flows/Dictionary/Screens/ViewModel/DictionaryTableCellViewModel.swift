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
    private(set) var isPrepareForDelete: Bool
    
    init(with translation: TranslationModel) {
        self.text = translation.fromText
        self.translation = translation.toText
        self.translationModel = translation
        self.isPrepareForDelete = false
    }
    
    public func state() {
        isPrepareForDelete.toggle()
    }
}
