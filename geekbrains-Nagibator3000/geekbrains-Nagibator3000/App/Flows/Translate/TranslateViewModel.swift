//
//  TranslateViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 02.08.2022.
//

import Foundation
import RxCocoa
import RxSwift

final class TranslateViewModel {   
    private(set) var sourceLanguage: BehaviorRelay<LanguageModel>
    private(set) var destinationLanguage: BehaviorRelay<LanguageModel>
    
    init?() {
        guard let languages = RepositoryLanguages.loadJson() else {
            return nil
        }
    
        self.sourceLanguage = BehaviorRelay<LanguageModel>(value: languages[0])
        self.destinationLanguage = BehaviorRelay<LanguageModel>(value: languages[0])
    }
    
    public func swapLanguages() {
        let sourceLanguage = self.destinationLanguage.value
        let destinationLanguage = self.sourceLanguage.value
        
        self.sourceLanguage.accept(sourceLanguage)
        self.destinationLanguage.accept(destinationLanguage)
    }
    
    public func configTranslateLanguage(language: LanguageModel, type: LanguageType) {
        type == .source ? sourceLanguage.accept(language) : destinationLanguage.accept(language)
    }
}

enum LanguageType {
    case source, destination
}
