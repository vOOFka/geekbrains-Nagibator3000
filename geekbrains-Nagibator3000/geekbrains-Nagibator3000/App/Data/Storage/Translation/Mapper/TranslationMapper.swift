//
//  TranslationMapper.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation

class TranslationMapper: Mapper<TranslationModel, TranslationStorageModel> {
  override func mapFromStorage(model: [TranslationStorageModel]) -> [TranslationModel] {
    model.map { model in TranslationModel(fromText: model.fromText, toText: model.toText) }
    
  }
  
  override func mapFromRepository(model: [TranslationModel]) -> [TranslationStorageModel] {
    model.map { model in TranslationStorageModel(fromText: model.fromText, toText: model.toText) }
  }
}
