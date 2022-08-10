//
//  UserDefaultsWrapper.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 08.08.2022.
//

import Foundation

class UserDefaultsWrapper {
  private let userDefaults = UserDefaults.standard

  func string(for key: String) -> String? {
    userDefaults.string(forKey: key)
  }

  func set(string: String, for key: String) {
    userDefaults.set(string, forKey: key)
    userDefaults.synchronize()
  }

  func delete(for key: String) {
    userDefaults.removeObject(forKey: key)
    userDefaults.synchronize()
  }
}
