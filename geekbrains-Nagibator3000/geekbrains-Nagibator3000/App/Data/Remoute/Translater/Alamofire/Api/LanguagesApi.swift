//
//  LanguagesApi.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 16.08.2022.
//

import Foundation
import RxSwift

public protocol LanguagesApi {
  var path: String { get }

  func get() -> Observable<LanguagesResponse>
}

public extension LanguagesApi {
  var path: String {
    WebUrlPath.languages
  }
}

