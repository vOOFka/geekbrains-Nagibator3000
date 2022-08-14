//
//  DataStorage.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 09.08.2022.
//

import Foundation

class DataStorage {
  private let controller: StorageController
  private let serialiser: JSONSerialiser

  init(
    controller: StorageController,
    serialiser: JSONSerialiser
  ) {
    self.controller = controller
    self.serialiser = serialiser
  }

  func read<T: Decodable>(completion: @escaping (T?) -> Void) {
    DispatchQueue.global().async {
      guard let storedString = self.controller.read(),
            let storedData = storedString.data(using: .utf8),
            let deserialised = self.serialiser.deserialise(T.self, from: storedData)
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

  func write<T: Encodable>(object: T, completion: @escaping (Bool) -> Void) {
    DispatchQueue.global().async {
      guard let serialised = self.serialiser.serialise(object)
      else {
        DispatchQueue.main.async {
          completion(false)
        }

        return
      }

      let storedData = String(data: serialised, encoding: .utf8)!
      self.controller.write(string: storedData)

      DispatchQueue.main.async {
        completion(true)
      }
    }
  }

  func clear(completion: @escaping (Bool) -> Void) {
    DispatchQueue.global().async {
      self.controller.clear()

      DispatchQueue.main.async {
        completion(true)
      }
    }
  }
}

