//
//  LanguageMapper.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation

class LanguageMapper: Mapper<Language, LanguageStorageModel> {
  override func mapFromStorage(model: [LanguageStorageModel]) -> [Language] {
    model.map { model in Language(code: model.code, name: model.name) }
  }
}
