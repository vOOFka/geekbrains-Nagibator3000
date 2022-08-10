//
//  TranslationMapper.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation

class TranslationMapper: Mapper<Translation, TranslationStorageModel> {
  override func mapFromStorage(model: [TranslationStorageModel]) -> [Translation] {
    model.map { model in Translation(fromText: model.fromText, toText: model.toText) }
    
  }
  
  override func mapFromRepository(model: [Translation]) -> [TranslationStorageModel] {
    model.map { model in TranslationStorageModel(fromText: model.fromText, toText: model.toText) }
  }
}
