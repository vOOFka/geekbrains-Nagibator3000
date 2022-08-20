//
//  TraslaterUseCase.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Foundation
import RxSwift

public class TranslaterUseCase {
  private let api: AFTranslateApi
  private let mapper: TranslateMapper

  init(api: AFTranslateApi, mapper: TranslateMapper) {
    self.api = api
    self.mapper = mapper
  }

  func traslate(fromText: String, params: TranslateParams) -> Observable<TranslationModel> {
    mapper.map(
      fromText: fromText ,
      observableResponse: api.traslate(translate: params)
    )
  }
}
