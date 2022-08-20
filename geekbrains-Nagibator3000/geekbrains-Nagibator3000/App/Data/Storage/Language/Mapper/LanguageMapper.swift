//
//  LanguageMapper.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation

class LanguageMapper: Mapper<LanguageModel, LanguageStorageModel> {
  override func mapFromStorage(model: [LanguageStorageModel]) -> [LanguageModel] {
    model.map { model in LanguageModel(code: model.code, name: model.name) }
  }
  
  override func mapFromRepository(model: [LanguageModel]) -> [LanguageStorageModel] {
    model.map { model in LanguageStorageModel(code: model.code, name: model.name) }
  }
}
