//
//  JSONSerialiser.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 08.08.2022.
//

import Foundation

class JSONSerialiser {
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  func serialise<T: Encodable>(_ object: T) -> Data? {
    guard let data = try? encoder.encode(object) else {
      return nil
    }

    return data
  }

  func deserialise<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
    try? decoder.decode(type, from: data)
  }
}
