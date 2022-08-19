//
//  LanguagesResponse.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 16.08.2022.
//

import Foundation

public struct LanguagesResponse: Codable {
  let languages: [Languages]?
}

public struct Languages: Codable {
  let code: String?
  let name: String?
}
