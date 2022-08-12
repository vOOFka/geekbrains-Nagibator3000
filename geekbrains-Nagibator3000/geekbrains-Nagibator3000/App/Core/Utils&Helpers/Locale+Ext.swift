//
//  Locale+Ext.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 11.08.2022.
//

import Foundation

extension Locale {
    static var preferredLanguageCode: String {
        guard let preferredLanguage = preferredLanguages.first,
              let code = Locale(identifier: preferredLanguage).languageCode else {
            return "ru"
        }
        return code
    }
    
    static var preferredLanguageCodes: [String] {
        return Locale.preferredLanguages.compactMap({Locale(identifier: $0).languageCode})
    }
}
