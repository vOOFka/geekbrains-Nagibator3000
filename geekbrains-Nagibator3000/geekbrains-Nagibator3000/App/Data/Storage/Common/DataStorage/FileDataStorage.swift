//
//  FileDataStorage.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation

class FileDataStorage {
  private let serialiser: JSONSerialiser

  init(
    serialiser: JSONSerialiser
  ) {
    self.serialiser = serialiser
  }

  func read<T: Decodable>(completion: @escaping (T?) -> Void) {
    DispatchQueue.global().async {
      guard let url = Bundle.main.url(forResource: StorageKeys.languages.rawValue, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let deserialised = self.serialiser.deserialise(T.self, from: data)
      else {
        DispatchQueue.main.async {
          completion(nil)
        }

        return
      }

      DispatchQueue.main.async {
        completion(deserialised)
      }
    }
  }
}
