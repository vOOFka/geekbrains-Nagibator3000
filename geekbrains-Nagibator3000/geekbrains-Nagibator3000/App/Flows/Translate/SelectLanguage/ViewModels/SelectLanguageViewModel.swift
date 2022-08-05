//
//  SelectLanguageViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 05.08.2022.
//

import Foundation

final class SelectLanguageViewModel {
    private(set) var translateViewModel: TranslateViewModel?
    private(set) var cellsArray: [SelectLanguageCellModel]?
    
    init(translateViewModel: TranslateViewModel) {
        self.translateViewModel = translateViewModel
    }
    
    public func update() {
        self.cellsArray = RepositoryLanguages.loadJson()?
            .compactMap{ SelectLanguageCellModel(language: $0, selected: false) }
    }
}
