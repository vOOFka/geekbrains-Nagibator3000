//
//  TRError.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 04.08.2022.
//

import Foundation

open class TRError: Error {
  let message: String
  let file: String

  public init(
    _ message: String,
    file: StaticString = #filePath
  ) {
    self.message = message
    self.file = "\(file)"
  }

  @available(*, unavailable)
  private init() {
    fatalError("init() is not impmemented")
  }
}
