//
//  TranslateViewModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 02.08.2022.
//

import Foundation

final class TranslateViewModel {
    private(set) var sourceLanguage: Language?
    private(set) var destinationLanguage: Language?
    
    init() {
        self.sourceLanguage = Language(id: "1", code: "ENG", name: "English", nativeName: "English", icon: nil)
        self.destinationLanguage = Language(id: "2", code: "RUS", name: "Russian", nativeName: "Русский", icon: nil)
    }
}
