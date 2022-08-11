//
//  Mapper.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 08.08.2022.
//

import Foundation

class Mapper<RepositoryModel, StorageModel: Codable> {
  func mapFromRepository(model: [RepositoryModel]) -> [StorageModel] {
    fatalError("This method needs to overriden")
  }

  func mapFromStorage(model: [StorageModel]) -> [RepositoryModel] {
    fatalError("This method needs to overriden")
  }
}
