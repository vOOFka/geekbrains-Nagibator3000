//
//  LanguageModelTemp.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 02.08.2022.
//

import Foundation

struct LanguageModelTemp: Codable {
    var code: String?
    var name: String?
    var nativeName: String?
    var icon: Data?
}

typealias LanguagesModelTemp = [LanguageModelTemp]

struct RepositoryLanguages {
    @discardableResult
    static func loadJson(fileName: String = "languages") -> LanguagesModelTemp {
       let decoder = JSONDecoder()
       guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let languages = try? decoder.decode(LanguagesModelTemp.self, from: data)
       else {
            return []
       }

       return languages
    }
}
