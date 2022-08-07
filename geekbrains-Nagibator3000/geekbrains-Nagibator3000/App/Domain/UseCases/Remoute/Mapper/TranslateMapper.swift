//
//  TraslateMapper.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Foundation
import RxSwift

public class TranslateMapper {
  public func map(
    fromText: String,
    observableResponse: Observable<TranslateResponse>
  ) -> Observable<Translate> {
    observableResponse
      .map { response in
        Translate(fromText: fromText, toText: response.text ?? "Error")
      }
  }
}
