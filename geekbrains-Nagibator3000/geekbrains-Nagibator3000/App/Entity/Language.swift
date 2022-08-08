//
//  Language.swift
//  geekbrains-Nagibator3000
//
//  Created by Home on 02.08.2022.
//

import Foundation

struct Language: Codable {
    var code: String?
    var name: String?
    var nativeName: String?
    var icon: Data?
}

typealias Languages = [Language]

struct RepositoryLanguages {
    @discardableResult
    static func loadJson(fileName: String = "Languages") -> Languages? {
       let decoder = JSONDecoder()
       guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let languages = try? decoder.decode(Languages.self, from: data)
       else {
            return nil
       }

       return languages
    }
}
