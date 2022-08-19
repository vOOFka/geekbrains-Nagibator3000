//
//  TranslationSectionModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 19.08.2022.
//

import Foundation
import RxDataSources

struct TranslationSectionModel {
    var header: String
    var items: [TranslationModel]
}

extension TranslationSectionModel: AnimatableSectionModelType {
    typealias Item = TranslationModel
    
    var identity: String {
        return header
    }
    
    init(original: TranslationSectionModel, items: [TranslationModel]) {
        self = original
        self.items = items
    }
}
