//
//  DictionaryUseCase.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation
import RxSwift

class DictionaryUseCase {
  let repository: TranslationRepository
  
  init(repository: TranslationRepository) {
    self.repository = repository
  }
  
  func get() -> Observable<[TranslationModel]> {
    repository.get()
  }

  func add(model: TranslationModel) -> Observable<Bool> {
    repository.add(model: model)
  }

  func delete(model: TranslationModel) -> Observable<Bool> {
    repository.delete(model: model)
  }

  func clear() -> Completable {
    repository.clear()
  }
}
