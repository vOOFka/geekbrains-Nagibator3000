//
//  DictionarySectionModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 19.08.2022.
//

import Foundation
import RxDataSources

struct DictionarySectionModel {
    var header: String
    var items: [TranslationModel]
}

extension DictionarySectionModel: AnimatableSectionModelType {
    typealias Item = TranslationModel
    
    var identity: String {
        return header
    }
    
    init(original: DictionarySectionModel, items: [TranslationModel]) {
        self = original
        self.items = items
    }
}
