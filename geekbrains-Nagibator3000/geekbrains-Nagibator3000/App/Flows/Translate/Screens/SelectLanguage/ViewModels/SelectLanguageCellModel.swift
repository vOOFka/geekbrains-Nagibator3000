//
//  SelectLanguageCellModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 05.08.2022.
//

import Foundation

final class SelectLanguageCellModel {
    private(set) var language: LanguageModel
    private(set) var isSelected: Bool
    
    init(language: LanguageModel, selected: Bool) {
        self.language = language
        self.isSelected = selected
    }
    
    public func selectLanguage() {
        isSelected.toggle()
    }
}
