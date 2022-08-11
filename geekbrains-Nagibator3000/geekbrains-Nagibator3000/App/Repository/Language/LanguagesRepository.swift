//
//  LanguagesRepository.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation
import RxSwift

class LanguagesRepository {
  let fileObjectAdapter: FileObjectBasedAdapter<Language, LanguageStorageModel>

  init (fileObjectAdapter: FileObjectBasedAdapter<Language, LanguageStorageModel>) {
    self.fileObjectAdapter = fileObjectAdapter
  }

  func get() -> Observable<[Language]> {
    fileObjectAdapter.read()
  }
}
