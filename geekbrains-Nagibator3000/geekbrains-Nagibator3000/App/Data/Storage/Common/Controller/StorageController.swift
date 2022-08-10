//
//  StorageController.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 08.08.2022.
//

import Foundation

class StorageController {
  private let userDefaults: UserDefaultsWrapper
  let key: String

  init(
    userDefaults: UserDefaultsWrapper,
    key: String
  ) {
    self.userDefaults = userDefaults
    self.key = key
  }

  func read() -> String? {
    return userDefaults.string(for: key)
  }

  func write(string: String) {
    userDefaults.set(string: string, for: key)
  }

  func clear() {
    userDefaults.delete(for: key)
  }
}
