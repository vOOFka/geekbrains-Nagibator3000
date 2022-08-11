//
//  LanguageModel.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 02.08.2022.
//

import Foundation

struct LanguageModel: Codable {
    var code: String?
    var name: String?
    var nativeName: String?
    var icon: Data?
}

typealias LanguagesModel = [LanguageModel]

struct RepositoryLanguages {
    @discardableResult
    static func loadJson(fileName: String = "languages") -> LanguagesModel? {
       let decoder = JSONDecoder()
       guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let languages = try? decoder.decode(LanguagesModel.self, from: data)
       else {
            return nil
       }

       return languages
    }
}
