//
//  TranslationRepository.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation
import RxSwift

class TranslationRepository {
  let objectAdapter: ObjectBasedAdapter<Translation, TranslationStorageModel>

  init (objectAdapter: ObjectBasedAdapter<Translation, TranslationStorageModel>) {
    self.objectAdapter = objectAdapter
  }

  func get() -> Observable<[Translation]> {
    objectAdapter.read()
  }

  func add(model: Translation) -> Observable<Bool> {
    let translations = objectAdapter.read()
      .map { translations -> [Translation] in
        var newTranslations = translations
        newTranslations.append(model)
        
        return newTranslations
      }

    return objectAdapter.write(model: translations)
  }

  func delete(model: Translation) -> Observable<Bool> {
    let translations = objectAdapter.read()
      .map { translations -> [Translation] in
        let index = translations.firstIndex { translation in
          translation.toText == model.toText
          && translation.fromText == model.toText
        }
        guard let index = index else { return translations }
        
        var newTranslations = translations
        newTranslations.remove(at: index)

        return newTranslations
      }

    return objectAdapter.write(model: translations)
  }

  func clear() -> Completable {
    objectAdapter.clear()
  }
}
