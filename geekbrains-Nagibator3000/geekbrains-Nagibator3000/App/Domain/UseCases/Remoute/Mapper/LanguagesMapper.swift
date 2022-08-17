//
//  LanguagesMapper.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 16.08.2022.
//

import Foundation
import RxSwift

public class LanguagesMapper {
  public func map(
    observableResponse: Observable<LanguagesResponse>
  ) -> Observable<[LanguageModel]> {
    observableResponse
      .map { [weak self] response in
        guard let self = self,
              let languages = response.languages else { return [] }
        
        return self.mapArray(languages: languages)
      }
  }
  
  private func mapArray(languages: [Languages]) -> [LanguageModel] {
    languages.compactMap { model in
      guard let code = model.code,
            let name = model.name else { return nil }
      
      return LanguageModel(code: code, name: name)
    }
  }
}
