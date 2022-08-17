//
//  LanguageUseCase.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 10.08.2022.
//

import Foundation
import RxSwift

class LanguageUseCase {
  private let repository: LanguagesRepository
  
  init(repository: LanguagesRepository) {
    self.repository = repository
  }
  
  func load() -> Observable<Bool> {
    repository.load()
  }
  
  func get() -> Observable<[LanguageModel]> {
    repository.get()
  }
}
