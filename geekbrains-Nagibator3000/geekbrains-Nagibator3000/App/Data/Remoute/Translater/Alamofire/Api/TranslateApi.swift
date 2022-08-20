//
//  TranslateApi.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Foundation
import RxSwift

public protocol TranslateApi {
  var path: String { get }

  func traslate(translate: TranslateParams) -> Observable<TranslateResponse>
  
}

public extension TranslateApi {
  var path: String {
    WebUrlPath.translate
  }
}
