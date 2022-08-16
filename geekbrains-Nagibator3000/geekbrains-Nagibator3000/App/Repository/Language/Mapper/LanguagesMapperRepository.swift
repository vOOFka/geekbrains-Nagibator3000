//
//  LanguagesMapperRepository.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 16.08.2022.
//

import Foundation
import RxSwift

class LanguagesMapperRepository {
  func map(response: LanguagesResponse) -> Observable<[LanguageModel]> {
    Observable<[LanguageModel]>.create { observable in
      guard let languages = response.languages else {
        observable.onError(OtherError())
        return Disposables.create()
      }
      
      let newLanguages: [LanguageModel] = languages.compactMap { model in
        guard let code = model.code,
              let name = model.name else { return nil }
        
        return LanguageModel(code: code, name: name)
      }
      
      observable.onNext(newLanguages)
      observable.onCompleted()
      return Disposables.create()
    }
  }
}
