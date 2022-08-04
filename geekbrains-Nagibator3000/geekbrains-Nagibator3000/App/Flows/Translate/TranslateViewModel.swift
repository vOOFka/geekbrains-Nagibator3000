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
    private(set) var sourceLanguage: BehaviorRelay<Language>
    private(set) var destinationLanguage: BehaviorRelay<Language>
    
    init() {
        let sourceLanguage = Language(id: "1", code: "ENG", name: "English", nativeName: "English", icon: nil)
        let destinationLanguage = Language(id: "2", code: "RUS", name: "Russian", nativeName: "Русский", icon: nil)
    
        self.sourceLanguage = BehaviorRelay<Language>(value: sourceLanguage)
        self.destinationLanguage = BehaviorRelay<Language>(value: destinationLanguage)
    }
    
    public func swapLanguages() {
        let sourceLanguage = self.destinationLanguage.value
        let destinationLanguage = self.sourceLanguage.value
        
        self.sourceLanguage.accept(sourceLanguage)
        self.destinationLanguage.accept(destinationLanguage)
    }
}
