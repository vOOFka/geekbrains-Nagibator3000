//
//  SelectLanguageViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 05.08.2022.
//

import Foundation

final class SelectLanguageViewModel {
    private(set) var translateViewModel: TranslateViewModel?
    private(set) var cellsArray: [SelectLanguageCellModel] = []
    
    private(set) var type: LanguageType = .source
    private(set) var selectIndex: Int = 0
    private(set) var selectLanguage: Language
    
    init(translateViewModel: TranslateViewModel, type: LanguageType) {
        self.translateViewModel = translateViewModel
        self.type = type
        self.selectLanguage = (type == .source) ? translateViewModel.sourceLanguage.value : translateViewModel.destinationLanguage.value
    }
    
    public func update(completion: @escaping () -> Void) {
        guard let repositoryLanguages = RepositoryLanguages.loadJson() else {
            return
        }
        cellsArray.removeAll()
        for (index, lang) in repositoryLanguages.enumerated() {
            if lang.code == selectLanguage.code {
                selectIndex = index
            }
            let cell = SelectLanguageCellModel(language: lang, selected: lang.code == selectLanguage.code)
            cellsArray.append(cell)
            
        }
        completion()
    }
    
    public func updateCell(with index: Int) {
        cellsArray[selectIndex].selectLanguage()
        cellsArray[index].selectLanguage()
        selectIndex = index
        
        if type == .source {
            translateViewModel?.sourceLanguage.accept(cellsArray[index].language)
        } else {
            translateViewModel?.destinationLanguage.accept(cellsArray[index].language)
        }
    }
}
