//
//  TranslateResponse.swift
//  geekbrains-Nagibator3000
//
//  Created by Valera Vvedenskiy on 05.08.2022.
//

import Foundation

//public struct TranslateResponse: Codable {
//  let result: Bool?
//  let text: String?
//  let times: Times?
//  let error: Int?
//  let description: String?
//}
//
//public struct Times: Codable {
//  let totalTime: Double?
//
//  enum CodingKeys: String, CodingKey {
//    case totalTime = "total_time"
//  }
//}

public struct TranslateResponse: Codable {
    let translations: [Translation]?
    let code: Int?
    let message: String?
    let details: [Detail]?
}

public struct Translation: Codable {
    let text, detectedLanguageCode: String
}

public struct Detail: Codable {
    let type, requestID: String

    enum CodingKeys: String, CodingKey {
        case type
        case requestID
    }
}
